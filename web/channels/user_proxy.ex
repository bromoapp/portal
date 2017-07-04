defmodule Portal.UserProxy do
    use Portal.Web, :channel
    alias Portal.ProxyPresence
    alias Portal.Relation
    alias Portal.Updates
    alias Portal.User
    alias Portal.DailyChat
    alias Portal.Chats
    alias Portal.Chat
    alias Ecto.Changeset
    alias Ecto.Adapters.SQL
    alias Mariaex.Result
    require Logger

    # Event topics
    @initial_updates "initial_updates"
    @friend_online "friend_online"
    @friend_offline "friend_offline"
    @p2p_msg_new "p2p_msg_new"
    @p2p_msg_in "p2p_msg_in"
    @p2p_msg_out "p2p_msg_out"
    @query_chats "query_chats"

    # SQLs
    @sql_ongoing_chats "CALL `sp_ongoing_chats`(?)"
    @sql_friends_list "CALL `sp_friends_list`(?)"
    @sql_query_chats "SELECT a.id, a.messages, a.updated_at, a.read FROM daily_chats AS a WHERE a.id = ?"
    @sql_get_chat "SELECT a.id FROM daily_chats AS a WHERE (DATE(a.updated_at) = CURDATE()) AND ((a.user_a_id = ? AND a.user_b_id = ?) OR (a.user_b_id = ? AND a.user_a_id = ?));"

    def join("user_proxy:" <> username, _params, socket) do
        send self(), :after_join
        {:ok, socket}
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

        # 3. Send initial updates for user on joined
        {_user, updates} = {socket.assigns.user, %Updates{}}
            |> _get_friends_list()
            |> _get_ongoing_chats()
        
        push socket, @initial_updates, updates
        
        # 4. Informs user's friends that he/she is online
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

    def handle_info({:p2p_msg_in, from, message}, socket) do
        push socket, @p2p_msg_in, %{from: from, msg: message}
        {:noreply, socket}
    end

    def handle_info({:p2p_msg_new, from, message}, socket) do
        push socket, @p2p_msg_new, %{from: from, msg: message}
        {:noreply, socket}
    end

    def handle_in(@p2p_msg_out, %{"to" => friend_uname, "msg" => message}, socket) do
        sender = socket.assigns.user
        friend = Repo.get_by!(User, username: friend_uname)
        ch = %Chat{from: sender.username, message: message, time: _format_time()}
        
        %Result{rows: rows} = SQL.query!(Repo, @sql_get_chat, [sender.id, friend.id, sender.id, friend.id])
        if rows == [] do
            # creates new chat
            chats = %Chats{chats: [ch]}
            text = Poison.encode!(chats)
            online? = _is_friend_online?(friend_uname)
            dchat_map = %{read: online?, messages: text}
                |> Map.put(:user_a, sender)
                |> Map.put(:user_b, friend)
            dchat_cs = DailyChat.create_or_update_changeset(%DailyChat{}, dchat_map)
                |> Changeset.put_assoc(:user_a, sender)
                |> Changeset.put_assoc(:user_b, friend)
            dchat = Repo.insert!(dchat_cs)

            Logger.info(">>> RUNTIME DATETIME #{inspect :calendar.local_time}")
            Logger.info(">>> CHAT NEW = #{inspect dchat}")
            #cond do
            #    online? == true ->
            #        ol_friend = OnlineUsersDb.select(friend_uname)
            #        json = %{id: id, date: date, chats: Poison.decode!(messages), read: read}
            #        send ol_friend.pid, {:p2p_msg_new, sender.username, message}
            #    true ->
            #        :ignore
            #end
        else
            # updates existing chat
            [[id]] = rows
            odchat = DailyChat
                |> Repo.get!(id)
            old_msgs = odchat.messages
            old_chats = Poison.decode!(old_msgs, as: %Chats{})
            upd_chat_list = %Chats{chats: old_chats.chats ++ [ch]}
            text = Poison.encode!(upd_chat_list)
            online? = _is_friend_online?(friend_uname)
            upd_dchat_map = %{read: online?, messages: text}
                |> Map.put(:user_a, sender)
                |> Map.put(:user_b, friend)

            upd_dchat_cs = DailyChat.create_or_update_changeset(odchat, upd_dchat_map)
            udchat = Repo.update!(upd_dchat_cs)

            Logger.info(">>> CHAT IN = #{inspect udchat}")
            #cond do
            #    online? == true ->
            #        ol_friend = OnlineUsersDb.select(friend_uname)
            #        send ol_friend.pid, {:p2p_msg_in, sender.username, message}
            #    true ->
            #        :ignore
            #end
        end
        {:noreply, socket}
    end

    def handle_in(@query_chats, %{"rec_id" => rec_id}, socket) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_query_chats, [rec_id])
        [[id, messages, {{yyyy, mm, dd}, _}, read]] = rows
        date = Integer.to_string(yyyy) <> "/" <> Integer.to_string(mm) <> "/" <> Integer.to_string(dd)
        json = %{id: id, date: date, chats: Poison.decode!(messages), read: read}
        {:reply, {:ok, %{"query_chats_resp" => json}}, socket}
    end

    defp _get_ongoing_chats({user, struct}) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_ongoing_chats, [user.id])
        chats = _parse_chats(rows, [])
        {user, %Updates{struct | chats: chats}}
    end

    defp _parse_chats([], result) do
        result
    end

    defp _parse_chats([h|t], result) do
        [friend_id, rec_id] = h
        nresult = result ++ [%{rec_id: rec_id, friend_id: friend_id, chats: nil, date: nil, read: nil}]
        _parse_chats(t, nresult)
    end

    defp _get_friends_list({user, struct}) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_friends_list, [user.id])
        {user, %Updates{struct | friends: _parse_friends(rows, [])}}
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
end