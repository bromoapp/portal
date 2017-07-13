defmodule Portal.UserProxy do
    use Portal.Web, :channel
    alias Ecto.Changeset
    alias Ecto.Adapters.SQL
    alias Mariaex.Result
    alias Portal.ProxyPresence
    alias Portal.Relation
    alias Portal.Updates
    alias Portal.User
    alias Portal.DailyChat
    alias Portal.Chats
    alias Portal.Chat
    alias Portal.Invitation
    require Logger

    # Event topics
    @friend_online "friend_online"
    @friend_offline "friend_offline"
    @p2p_msg_in "p2p_msg_in"
    @p2p_msg_out "p2p_msg_out"
    @p2p_msg_new "p2p_msg_new"
    @p2p_msg_read "p2p_msg_read"
    @add_friend_in "add_friend_in"
    @add_friend_out "add_friend_out"
    @add_friend_resp "add_friend_resp"
    @add_friend_opened "add_friend_opened"
    @query_chats "query_chats"

    # SQLs
    @sql_ongoing_chats "CALL `sp_ongoing_chats`(?);"
    @sql_friends_list "CALL `sp_friends_list`(?);"
    @sql_invitations_list "SELECT * FROM invitations AS a WHERE a.to_id = ? AND a.`status` != 'IGNORED'"
    @sql_query_chats "SELECT a.id, a.user_b_id, a.messages, a.updated_at, a.read FROM daily_chats AS a WHERE a.id = ?;"
    @sql_get_chat "SELECT a.id FROM daily_chats AS a WHERE DATE(a.updated_at) = CURDATE() AND a.user_a_id = ? AND a.user_b_id = ?;"

    #=================================================================================================
    # Functions related to user connections and presences
    #=================================================================================================
    def join("user_proxy:" <> username, _params, socket) do
        send self(), :after_join
        Logger.info(">>> JOIN #{inspect username} IN #{inspect self()}")

        {_user, updates} = {socket.assigns.user, %Updates{}}
        |> _get_friends_list()
        |> _get_ongoing_chats()
        |> _get_invitations_list()
        {:ok, updates, socket}
    end
    
    def terminate(_reason, socket) do
        user = socket.assigns.user
        
        # 1. Inform user's friends that he/she is offline
        {_user, updates} = _get_friends_list({user, %Updates{}})
        updates.friends |>
            Enum.each(fn(friend) ->
                cond do
                    friend.online == true ->
                        ol_friend = OnlineUsersDb.select(friend.username)
                        cond do
                            ol_friend != nil ->
                                send ol_friend.pid, {:friend_offline, user}
                            true ->
                                :ignore
                        end
                    true ->
                        :ignore
                end
            end)
        
        # 2. Delete user from db
        OnlineUsersDb.delete(user.username)
        {:noreply, socket}
    end

    def handle_info(:after_join, socket) do
        # 1. Tracking user with presence
        user = socket.assigns.user
        ProxyPresence.track(socket, user.username, %{
            name: user.name,
            online_at: :os.system_time(:milli_seconds)
        })

        # 2. Insert user to distributed db
        ol_user = %OnlineUser{
            name: user.name,
            username: user.username,
            node: node(),
            pid: self()
        }
        OnlineUsersDb.insert(ol_user)
        
        # 3. Informs user's friends that he/she is online
        {_user, updates} = {socket.assigns.user, %Updates{}}
        |> _get_friends_list()

        updates.friends |>
            Enum.each(fn(friend) ->
                cond do
                    friend.online == true ->
                        ol_friend = OnlineUsersDb.select(friend.username)
                        cond do
                            ol_friend != nil ->
                                send ol_friend.pid, {:friend_online, user}
                            true ->
                                :ignore
                        end
                    true ->
                        :ignore
                end
            end)

        {:noreply, socket}
    end

    def handle_info({:friend_online, friend}, socket) do
        push socket, @friend_online, %{id: friend.id, username: friend.username, name: friend.name, online: true}
        {:noreply, socket}
    end

    def handle_info({:friend_offline, friend}, socket) do
        push socket, @friend_offline, %{id: friend.id, username: friend.username, name: friend.name, online: false}
        {:noreply, socket}
    end

    defp _get_invitations_list({user, struct}) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_invitations_list, [user.id])
        if rows == [] do
            {user, %Updates{struct | invits: []}}
        else
            {user, %Updates{struct | invits: _parse_invits(rows, [])}}
        end
    end

    defp _parse_invits([], result) do
        result
    end

    defp _parse_invits([h|t], result) do
        [id, from_id, _to, type, message, status, _, _] = h
        friend = User |> Repo.get!(from_id)
        nresult = result ++ [%{id: id, from_id: from_id, from_name: friend.name, type: type, status: status, msg: message}]
        _parse_invits(t, nresult)
    end

    defp _get_ongoing_chats({user, struct}) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_ongoing_chats, [user.id])
        if rows == [] do
            {user, %Updates{struct | chats: []}}
        else
            {user, %Updates{struct | chats: _parse_chats(rows, [])}}
        end
    end

    defp _parse_chats([], result) do
        result
    end

    defp _parse_chats([h|t], result) do
        [friend_id, id] = h
        nresult = result ++ [%{id: id, friend_id: friend_id, chats: nil, date: nil, read: nil}]
        _parse_chats(t, nresult)
    end

    defp _get_friends_list({user, struct}) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_friends_list, [user.id])
        if rows == [] do
            {user, %Updates{struct | friends: []}}
        else
            {user, %Updates{struct | friends: _parse_friends(rows, [])}}
        end
    end

    defp _parse_friends([], result) do
        result
    end

    defp _parse_friends([[id, name, username]|t], result) do
        ol_user = OnlineUsersDb.select(username)
        cond do
            ol_user == nil ->
                n_result = result ++ [%{id: id, username: username, name: name, online: false}]
                _parse_friends(t, n_result)
            true ->
                n_result = result ++ [%{id: id, username: username, name: name, online: true}]
                _parse_friends(t, n_result)
        end
    end

    #=================================================================================================
    # Functions related to p2p chats
    #=================================================================================================
    def handle_info({:p2p_msg_new, message}, socket) do
        push socket, @p2p_msg_new, message
        {:noreply, socket}
    end

    def handle_info({:p2p_msg_in, message}, socket) do
        push socket, @p2p_msg_in, message
        {:noreply, socket}
    end

    def handle_in(@p2p_msg_out, %{"to" => friend_uname, "msg" => message}, socket) do
        sender = socket.assigns.user
        receiver = Repo.get_by(User, username: friend_uname)
        if (receiver != nil) do
            chat = %Chat{from: sender.username, message: message, time: _format_time()}
            {mode1, json1} = _create_update_users_chat(sender, receiver, chat)
            {mode2, json2} = _create_update_users_chat(receiver, sender, chat)

            cond do
                mode1 == :p2p_msg_new ->
                    push socket, @p2p_msg_new, json1
                true ->
                    push socket, @p2p_msg_in, json1
            end 

            receiver_online? = _is_friend_online?(receiver.username)
            if receiver_online? == true do
                ol_friend = OnlineUsersDb.select(receiver.username)
                cond do
                    mode2 == :p2p_msg_new ->
                        send ol_friend.pid, {:p2p_msg_new, json2}
                    true ->
                        send ol_friend.pid, {:p2p_msg_in, json2}
                end
            end
            {:noreply, socket}
        else
            {:reply, {:error, %{"msg" => "Email not found!"}}, socket}
        end
    end

    def handle_in(@query_chats, %{"id" => id}, socket) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_query_chats, [id])
        if rows == [] do
            {:reply, {:ok, %{"query_chats_resp" => %{}}}, socket}
        else
            [[id, user_b_id, messages, date_time, read]] = rows
            raw = Poison.decode!(messages)
            json = %{id: id, friend_id: user_b_id, date: _format_date(date_time), chats: raw["chats"], read: read}

            {:reply, {:ok, %{"query_chats_resp" => json}}, socket}
        end
    end

    def handle_in(@p2p_msg_read, %{"id" => id}, socket) do
        Logger.info(">>> READ CHAT ID: #{inspect id}")
        {:noreply, socket}
    end

    defp _create_update_users_chat(user_a, user_b, chat) do
        #Logger.info(">>> USER A = #{inspect user_a.username}")
        %Result{rows: rows} = SQL.query!(Repo, @sql_get_chat, [user_a.id, user_b.id])
        if rows == [] do
            # creates new chat for user
            chats = %Chats{chats: [chat]}
            text = Poison.encode!(chats)
            user_a_chat_map = %{read: false, messages: text}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)
            user_a_chat_cs = DailyChat.create_or_update_changeset(%DailyChat{}, user_a_chat_map)
            |> Changeset.put_assoc(:user_a, user_a)
            |> Changeset.put_assoc(:user_b, user_b)
            user_a_chat = Repo.insert!(user_a_chat_cs)

            raw = Poison.decode!(user_a_chat.messages)
            json = %{id: user_a_chat.id, friend_id: user_b.id, date: _format_date(user_a_chat.inserted_at), chats: raw["chats"], read: 1}
            {:p2p_msg_new, json}
        else
            # updates existing chat
            [[id]] = rows
            user_a_chat = DailyChat |> Repo.get!(id)
            old_user_a_chats = Poison.decode!(user_a_chat.messages, as: %Chats{})
            upd_user_a_chat_list = %Chats{chats: old_user_a_chats.chats ++ [chat]}
            text = Poison.encode!(upd_user_a_chat_list)
            upd_user_a_chat_map = %{read: false, messages: text}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)

            upd_user_a_chat_cs = DailyChat.create_or_update_changeset(user_a_chat, upd_user_a_chat_map)
            upd_user_a_chat = Repo.update!(upd_user_a_chat_cs)
            
            %Portal.Chat{from: uname, message: message, time: time} = chat
            nchat = %{"from" => uname, "message" => message, "time" => time}
            json = %{id: upd_user_a_chat.id, friend_id: user_b.id, date: _format_date(upd_user_a_chat.updated_at), chats: [nchat], read: 1}
            {:p2p_msg_in, json}
        end
    end

    #=================================================================================================
    # Functions related to add friend
    #=================================================================================================
    def handle_info({:add_friend_in, invit}, socket) do
        push socket, @add_friend_in, invit
        {:noreply, socket}
    end

    def handle_in(@add_friend_out, %{"email" => email, "msg" => message}, socket) do
        sender = socket.assigns.user
        receiver = Repo.get_by(User, username: email)
        if (receiver != nil) do
            invit_map = %{invit_type: "FRIENDSHIP", invit_msg: message, status: "WAITING"}
            |> Map.put(:from, sender)
            |> Map.put(:to, receiver)
            invit_cs = Invitation.create_changeset(%Invitation{}, invit_map)
            |> Changeset.put_assoc(:from, sender)
            |> Changeset.put_assoc(:to, receiver)
            invit = Repo.insert!(invit_cs)

            online? = _is_friend_online?(receiver.username)
            cond do
                online? == true ->
                    ol_friend = OnlineUsersDb.select(receiver.username)
                    json = %{id: invit.id, from_id: invit.from_id, from_name: sender.name, type: invit.invit_type, status: invit.status, msg: message}
                    send ol_friend.pid, {:add_friend_in, json}
                true ->
                    :ignore
            end
            
            {:reply, :ok, socket}
        else
            {:reply, {:error, %{"msg" => "Email not found!"}}, socket}
        end
    end

    def handle_in(@add_friend_resp, %{"id" => id, "resp" => resp}, socket) do
        invit = Invitation |> Repo.get(id)
        Logger.info("#{inspect invit}")
        {:noreply, socket}
    end

    def handle_in(@add_friend_opened, %{"id" => id}, socket) do
        {:noreply, socket}
    end

    #=================================================================================================
    # Helper functions
    #=================================================================================================
    defp _is_friend_online?(uname) do
        ol_friend = OnlineUsersDb.select(uname)
        cond do
            ol_friend != nil ->
                true
            true ->
                false
        end
    end

    defp _format_time do
        {_, {hh, mm, ss}} = :calendar.local_time
        Integer.to_string(hh) <> ":" <> Integer.to_string(mm) <> ":" <> Integer.to_string(ss)
    end

    defp _format_date({{yyyy, mm, dd}, _}) do
        Integer.to_string(yyyy) <> "/" <> Integer.to_string(mm) <> "/" <> Integer.to_string(dd)
    end

    defp _format_date(ecto_date) do
        {{yyyy, mm, dd}, _} = Ecto.DateTime.to_erl(ecto_date)
        Integer.to_string(yyyy) <> "/" <> Integer.to_string(mm) <> "/" <> Integer.to_string(dd)
    end
end