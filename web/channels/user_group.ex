defmodule Portal.UserGroup do
    use Portal.Web, :channel
    alias Portal.User
    alias Portal.Chat
    alias Portal.Group
    alias Portal.Chats
    alias Mariaex.Result
    alias Ecto.Changeset
    alias Portal.DailyChat
    alias Portal.OnlineUser
    alias Ecto.Adapters.SQL
    alias Portal.GroupUpdates
    alias Portal.OnlineUsersDb
    alias Portal.GroupPresence
    require Logger

    @group_not_found "Group not found!"
    
    @chat_p2g "P2G"
    
    # Event topics
    @broadcast_msg "broadcast_msg"
    @p2g_msg_out "p2g_msg_out"
    @p2g_msg_new "p2g_msg_new"
    @p2g_msg_in "p2g_msg_in"
    @query_chats "query_chats"

    # SQLs
    @sql_ongoing_gchats "CALL `sp_ongoing_gchats`(?);"
    @sql_query_gchats "SELECT a.id, a.counter_id, a.messages, a.inserted_at, a.read, a.`type` FROM daily_chats AS a WHERE a.id = ?;"
    @sql_get_chat "SELECT a.id FROM daily_chats AS a WHERE DATE(a.inserted_at) = STR_TO_DATE(?, '%Y-%m-%d') AND a.user_id = ? AND a.counter_id = ? AND a.`type` = 'P2G';"
    
    #=================================================================================================
    # Functions related to members connections and presences
    #=================================================================================================
    def join("user_group:" <> unique, _params, socket) do
        send self(), :after_join

        {_socket, updates} = {socket, %GroupUpdates{}}
        |> _get_admins_list()
        |> _get_members_list()
        |> _get_ongoing_chats()
        {:ok, updates, socket}
    end

    def terminate(_reason, socket) do
        user = socket.assigns.user
        GroupPresence.untrack(socket, user.username)
        {:noreply, socket}
    end

    def handle_info(:after_join, socket) do
        user = socket.assigns.user
        GroupPresence.track(socket, user.username, %{name: user.name, username: user.username})
        {:noreply, socket}
    end

    defp _get_admins_list({socket, struct}) do
        unique = _parse_unique(socket.topic)
        group = Repo.get_by(Group, unique: unique)
        if (group != nil) do
            admins = _get_group_members(String.split(group.admins, ","))
            |> Enum.map(fn(x) -> %{name: x.name, username: x.username} end)
            {socket, %GroupUpdates{struct | admins: admins}}
        else
            {socket, %GroupUpdates{struct | admins: []}}
        end
    end

    defp _get_members_list({socket, struct}) do
        unique = _parse_unique(socket.topic)
        user = socket.assigns.user
        group = Repo.get_by(Group, unique: unique)
        if (group != nil) do
            members = _get_group_members(String.split(group.members, ","))
            |> Enum.map(fn(x) -> %{name: x.name, username: x.username} end)
            {socket, %GroupUpdates{struct | members: members}}
        else
            {socket, %GroupUpdates{struct | members: []}}
        end
    end

    defp _get_ongoing_chats({socket, struct}) do
        user = socket.assigns.user
        %Result{rows: rows} = SQL.query!(Repo, @sql_ongoing_gchats, [user.id])
        if rows == [] do
            {socket, %GroupUpdates{struct | chats: []}}
        else
            {socket, %GroupUpdates{struct | chats: _parse_gchats(rows, [])}}
        end
    end

    defp _parse_gchats([], result) do
        result
    end

    defp _parse_gchats([h|t], result) do
        [counter_id, id, read, type] = h
        nresult = result ++ [%{id: id, counter_id: counter_id, chats: nil, date: nil, read: read, type: type}]
        _parse_gchats(t, nresult)
    end

    #=================================================================================================
    # Functions related to p2g chats
    #=================================================================================================
    def handle_in(@p2g_msg_out, %{"msg" => message}, socket) do
        user = socket.assigns.user

        # Broadcast chat to online members
        broadcast!(socket, @broadcast_msg, %{sender: user.username, msg: message})

        # Send chat to offline members
        chat = %Chat{from: user.username, message: message, time: _format_time()}
        unique = _parse_unique(socket.topic)
        group = Repo.get_by(Group, unique: unique)
        _get_group_members(String.split(group.members, ","))
        |> Enum.filter(fn(a) -> _is_member_online?(a.username) == false end)
        |> Enum.each(fn(b) -> _create_update_group_chat(b, group, chat) end)
        {:noreply, socket}
    end

    intercept [@broadcast_msg]
    def handle_out(@broadcast_msg, data, socket) do
        user = socket.assigns.user
        unique = _parse_unique(socket.topic)
        
        group = Repo.get_by(Group, unique: unique)
        if (group != nil) do
            %{sender: username, msg: message} = data
            chat = %Chat{from: username, message: message, time: _format_time()}
            case _create_update_group_chat(user, group, chat) do
                {:p2g_msg_new, json} ->
                    push socket, @p2g_msg_new, json
                {:p2g_msg_in, json} ->
                    push socket, @p2g_msg_in, json
                {:error, changeset} ->
                    Logger.error(">>> ERROR #{inspect changeset}")
            end
        end
        {:noreply, socket}
    end

    defp _create_update_group_chat(user, group, chat) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_get_chat, [_format_date(:calendar.universal_time), user.id, group.id])
        if rows == [] do
            # creates new chat for user
            chats = %Chats{chats: [chat]}
            text = Poison.encode!(chats)
            user_gchat_map = %{read: false, messages: text, type: @chat_p2g, counter_id: group.id}
            |> Map.put(:user, user)
            user_gchat_cs = DailyChat.create_or_update_p2g_changeset(%DailyChat{}, user_gchat_map)
            |> Changeset.put_assoc(:user, user)

            case Repo.insert(user_gchat_cs) do
                {:ok, user_gchat} ->
                    raw = Poison.decode!(user_gchat.messages)
                    json = %{id: user_gchat.id, counter_id: group.id, date: _format_date(user_gchat.inserted_at), 
                        chats: raw["chats"], read: false, type: @chat_p2g}
                    {:p2g_msg_new, json}
                {:error, changeset} ->
                    {:error, changeset}
            end
        else
            # updates existing chat
            [[id]] = rows
            user_gchat = DailyChat |> Repo.get!(id)
            old_user_gchats = Poison.decode!(user_gchat.messages, as: %Chats{})
            upd_user_gchat_list = %Chats{chats: old_user_gchats.chats ++ [chat]}
            text = Poison.encode!(upd_user_gchat_list)
            upd_user_gchat_map = %{read: false, messages: text}
            |> Map.put(:user, user)

            upd_user_gchat_cs = DailyChat.create_or_update_p2g_changeset(user_gchat, upd_user_gchat_map)

            case Repo.update(upd_user_gchat_cs) do
                {:ok, upd_user_gchat} ->
                    %Chat{from: uname, message: message, time: time} = chat
                    nchat = %{"from" => uname, "message" => message, "time" => time}
                    json = %{id: upd_user_gchat.id, counter_id: group.id, date: _format_date(upd_user_gchat.updated_at), 
                        chats: [nchat], read: false, type: @chat_p2g}
                    {:p2g_msg_in, json}
                {:error, changeset} ->
                    {:error, changeset}
            end
        end
    end
    
    def handle_in(@query_chats, %{"id" => id}, socket) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_query_gchats, [id])
        if rows == [] do
            {:reply, {:ok, %{"query_chats_resp" => %{}}}, socket}
        else
            [[id, counter_id, messages, date_time, read, type]] = rows
            raw = Poison.decode!(messages)
            if read == 0 do
                chat = DailyChat |> Repo.get!(id)
                upd_chat_map = %{read: true}
                upd_chat_cs = DailyChat.create_or_update_p2p_changeset(chat, upd_chat_map)
                case Repo.update(upd_chat_cs) do
                    {:ok, _} ->
                        :ignore
                    {:error, changeset} ->
                        Logger.error(">>> ERROR #{inspect changeset}")
                end
            end

            json = %{id: id, counter_id: counter_id, date: _format_date(date_time), chats: raw["chats"], read: 0, type: type}
            {:reply, {:ok, %{"query_chats_resp" => json}}, socket}
        end
    end
    
    #=================================================================================================
    # Helper functions
    #=================================================================================================
    defp _is_member_online?(uname) do
        ol_member = OnlineUsersDb.select(uname)
        cond do
            ol_member != nil ->
                true
            true ->
                false
        end
    end

    defp _parse_unique(topic) do
        [_h, unique] = String.split(topic, ":")
        unique
    end

    defp _get_group_members(list) do
        Enum.map(list, fn(x) -> 
            id = Regex.replace(~r/#/, x, "")
            String.to_integer(id)
        end) |>
        Enum.map(fn(n) -> 
            Repo.get!(User, n)
        end)
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