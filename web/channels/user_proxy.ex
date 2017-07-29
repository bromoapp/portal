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

    # Message
    @email_not_found "Email not found!"

    # Constant
    @friendship "FRIENDSHIP"
    @waiting "WAITING"
    @accepted "ACCEPTED"
    @rejected "REJECTED"
    @ignored "IGNORED"

    # Event topics
    @friend_new "friend_new"
    @friend_online "friend_online"
    @friend_offline "friend_offline"
    @query_chats "query_chats"
    @p2p_msg_in "p2p_msg_in"
    @p2p_msg_out "p2p_msg_out"
    @p2p_msg_new "p2p_msg_new"
    @p2p_msg_read "p2p_msg_read"
    @add_friend_in "add_friend_in"
    @add_friend_out "add_friend_out"
    @add_friend_resp "add_friend_resp"
    @add_friend_opened "add_friend_opened"

    # SQLs
    @sql_is_invit_exists "CALL `sp_is_invit_exists`(?, ?);"
    @sql_ongoing_chats "CALL `sp_ongoing_chats`(?);"
    @sql_friends_list "CALL `sp_friends_list`(?);"
    @sql_invitations_list "SELECT * FROM invitations AS a WHERE a.to_id = ? AND a.`status` = 'WAITING'"
    @sql_query_chats "SELECT a.id, a.user_b_id, a.messages, a.updated_at, a.read FROM daily_chats AS a WHERE a.id = ?;"
    @sql_get_chat "SELECT a.id FROM daily_chats AS a WHERE DATE(a.inserted_at) = STR_TO_DATE(?, '%Y-%m-%d') AND a.user_a_id = ? AND a.user_b_id = ?;"

    #=================================================================================================
    # Functions related to user connections and presences
    #=================================================================================================
    def join("user_proxy:" <> username, _params, socket) do
        send self(), :after_join

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
        [id, from_id, _to, type, message, status, opened, _, _] = h
        friend = User |> Repo.get!(from_id)
        nresult = result ++ [%{id: id, from_id: from_id, from_name: friend.name, type: type, status: status, msg: message, opened: opened}]
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
        [friend_id, id, read] = h
        nresult = result ++ [%{id: id, friend_id: friend_id, chats: nil, date: nil, read: read}]
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
            {mode1, json1} = _create_update_users_chat(sender, receiver, chat, :sender)
            {mode2, json2} = _create_update_users_chat(receiver, sender, chat, :receiver)

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
            {:reply, {:error, %{"msg" => @email_not_found}}, socket}
        end
    end

    def handle_in(@query_chats, %{"id" => id}, socket) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_query_chats, [id])
        if rows == [] do
            {:reply, {:ok, %{"query_chats_resp" => %{}}}, socket}
        else
            [[id, user_b_id, messages, date_time, read]] = rows
            raw = Poison.decode!(messages)
            if read == 0 do
                chat = DailyChat |> Repo.get!(id)
                upd_chat_map = %{read: true}
                upd_chat_cs = DailyChat.create_or_update_p2p_changeset(chat, upd_chat_map)
                Repo.update(upd_chat_cs)
            end

            json = %{id: id, friend_id: user_b_id, date: _format_date(date_time), chats: raw["chats"], read: 1}

            {:reply, {:ok, %{"query_chats_resp" => json}}, socket}
        end
    end

    def handle_in(@p2p_msg_read, %{"id" => id}, socket) do
        chat = DailyChat |> Repo.get!(id)
        upd_chat_map = %{read: true}
        upd_chat_cs = DailyChat.create_or_update_p2p_changeset(chat, upd_chat_map)
        Repo.update(upd_chat_cs)
        {:noreply, socket}
    end

    defp _create_update_users_chat(user_a, user_b, chat, mode) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_get_chat, [_format_date(:calendar.universal_time), user_a.id, user_b.id])
        if rows == [] do
            # creates new chat for user
            chats = %Chats{chats: [chat]}
            text = Poison.encode!(chats)
            user_a_chat_map = %{read: _parse_read_val(mode), messages: text}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)
            user_a_chat_cs = DailyChat.create_or_update_p2p_changeset(%DailyChat{}, user_a_chat_map)
            |> Changeset.put_assoc(:user_a, user_a)
            |> Changeset.put_assoc(:user_b, user_b)
            user_a_chat = Repo.insert!(user_a_chat_cs)

            raw = Poison.decode!(user_a_chat.messages)
            json = %{id: user_a_chat.id, friend_id: user_b.id, date: _format_date(user_a_chat.inserted_at), 
                chats: raw["chats"], read: _parse_bool_val(user_a_chat.read)}
            {:p2p_msg_new, json}
        else
            # updates existing chat
            [[id]] = rows
            user_a_chat = DailyChat |> Repo.get!(id)
            old_user_a_chats = Poison.decode!(user_a_chat.messages, as: %Chats{})
            upd_user_a_chat_list = %Chats{chats: old_user_a_chats.chats ++ [chat]}
            text = Poison.encode!(upd_user_a_chat_list)
            upd_user_a_chat_map = %{read: _parse_read_val(mode), messages: text}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)

            upd_user_a_chat_cs = DailyChat.create_or_update_p2p_changeset(user_a_chat, upd_user_a_chat_map)
            upd_user_a_chat = Repo.update!(upd_user_a_chat_cs)
            
            %Chat{from: uname, message: message, time: time} = chat
            nchat = %{"from" => uname, "message" => message, "time" => time}
            json = %{id: upd_user_a_chat.id, friend_id: user_b.id, date: _format_date(upd_user_a_chat.updated_at), 
                chats: [nchat], read: _parse_bool_val(upd_user_a_chat.read)}
            {:p2p_msg_in, json}
        end
    end
    
    defp _parse_read_val(mode) do
        cond do
            mode == :sender ->
                true
            true ->
                false
        end
    end

    defp _parse_bool_val(bool) do
        cond do
            bool == true ->
                1
            true ->
                0
        end
    end

    #=================================================================================================
    # Functions related to add friend
    #=================================================================================================
    def handle_info({:add_friend_in, invit}, socket) do
        push socket, @add_friend_in, invit
        {:noreply, socket}
    end

    def handle_info({:friend_new, json}, socket) do
        push socket, @friend_new, json
        {:noreply, socket}
    end

    def handle_in(@add_friend_out, %{"email" => email, "msg" => message}, socket) do
        sender = socket.assigns.user
        receiver = Repo.get_by(User, username: email)
        if (receiver != nil) do
            %Result{rows: rows} = SQL.query!(Repo, @sql_is_invit_exists, [sender.id, receiver.id])
            [[total]] = rows
            cond do
                total == 0 ->
                    invit_map = %{invit_type: @friendship, invit_msg: message, status: @waiting}
                    |> Map.put(:from, sender)
                    |> Map.put(:to, receiver)
                    invit_cs = Invitation.create_or_update_changeset(%Invitation{}, invit_map)
                    |> Changeset.put_assoc(:from, sender)
                    |> Changeset.put_assoc(:to, receiver)
                    invit = Repo.insert!(invit_cs)

                    online? = _is_friend_online?(receiver.username)
                    cond do
                        online? == true ->
                            ol_friend = OnlineUsersDb.select(receiver.username)
                            json = %{id: invit.id, from_id: invit.from_id, from_name: sender.name, 
                                type: invit.invit_type, status: invit.status, msg: message}
                            send ol_friend.pid, {:add_friend_in, json}
                        true ->
                            :ignore
                    end
                true ->
                    :ignore
            end
            {:reply, :ok, socket}
        else
            {:reply, {:error, %{"msg" => @email_not_found}}, socket}
        end
    end

    def handle_in(@add_friend_resp, %{"id" => id, "resp" => resp}, socket) do
        invit = Invitation 
        |> Repo.get(id)
        |> Repo.preload(:from)
        |> Repo.preload(:to)

        user_a = invit.from
        user_b = invit.to
        cond do
            resp == @accepted ->
                upd_invit_cs = Invitation.create_or_update_changeset(invit, %{status: @accepted})
                Repo.update(upd_invit_cs)

                rel_map = %{tags: invit.invit_type}
                |> Map.put(:user_a, user_a)
                |> Map.put(:user_b, user_b)

                rel_cs = Relation.create_changeset(%Relation{}, rel_map)
                |> Changeset.put_assoc(:user_a, user_a)
                |> Changeset.put_assoc(:user_b, user_b)
                Repo.insert(rel_cs)

                json1 = %{id: user_a.id, username: user_a.username, name: user_a.name, online: _is_friend_online?(user_a.username)}
                push socket, @friend_new, json1

                online? = _is_friend_online?(user_a.username)
                cond do
                    online? == true ->
                        ol_friend = OnlineUsersDb.select(user_a.username)
                        json2 = %{id: user_b.id, username: user_b.username, name: user_b.name, online: _is_friend_online?(user_b.username)}
                        send ol_friend.pid, {:friend_new, json2}
                        
                        # Inform each side that his/her new friend is online
                        :timer.sleep(500)
                        send ol_friend.pid, {:friend_online, user_b}
                        send self(), {:friend_online, user_a}
                    true ->
                        :ignore
                end
            resp == @rejected ->
                upd_invit_cs = Invitation.create_or_update_changeset(invit, %{status: @rejected})
                Repo.update(upd_invit_cs)
            resp == @ignored ->
                upd_invit_cs = Invitation.create_or_update_changeset(invit, %{status: @ignored})
                Repo.update(upd_invit_cs)                
            true ->
                upd_invit_cs = Invitation.create_or_update_changeset(invit, %{status: @ignored})
                Repo.update(upd_invit_cs)
        end
        {:noreply, socket}
    end

    def handle_in(@add_friend_opened, %{"id" => id}, socket) do
        invit = Invitation |> Repo.get!(id)
        upd_invit_cs = Invitation.create_or_update_changeset(invit, %{opened: true})
        Repo.update(upd_invit_cs)
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
        {{year, month, date}, {hh, mm, ss}} = :calendar.universal_time
        Integer.to_string(year) <> "/" <> Integer.to_string(month) <> "/" <> Integer.to_string(date)
        <> " " <> Integer.to_string(hh) <> ":" <> Integer.to_string(mm) <> ":" <> Integer.to_string(ss)
    end

    defp _format_date(date) when is_tuple(date) do
        {{yyyy, mm, dd}, _} = date
        Integer.to_string(yyyy) <> "-" <> Integer.to_string(mm) <> "-" <> Integer.to_string(dd)
    end

    defp _format_date(universal_time) do
        {{yyyy, mm, dd}, _} = NaiveDateTime.to_erl(universal_time)
        Integer.to_string(yyyy) <> "-" <> Integer.to_string(mm) <> "-" <> Integer.to_string(dd)
    end

end