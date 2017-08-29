defmodule Portal.UserProxy do
    use Portal.Web, :channel
    alias Ecto.Changeset
    alias Ecto.Adapters.SQL
    alias Mariaex.Result
    alias Portal.ProxyPresence
    alias Portal.Invitation
    alias Portal.GroupChat
    alias Portal.DailyChat
    alias Portal.Relation
    alias Portal.Updates
    alias Portal.Group
    alias Portal.Chats
    alias Portal.User
    alias Portal.Chat
    require Logger

    # Message
    @email_not_found "Email not found!"

    # Constant
    @friendship "FRIENDSHIP"
    @membership "MEMBERSHIP"
    @waiting "WAITING"
    @accepted "ACCEPTED"
    @rejected "REJECTED"
    @ignored "IGNORED"

    # Chat types
    @chat_p2p "P2P"

    # Event topics
    @friend_online "friend_online"
    @friend_offline "friend_offline"
    @query_chats "query_chats"

    @p2p_msg_in "p2p_msg_in"
    @p2p_msg_out "p2p_msg_out"
    @p2p_msg_new "p2p_msg_new"
    @p2p_msg_read "p2p_msg_read"
    
    @friend_new "friend_new"
    @add_friend_in "add_friend_in"
    @add_friend_out "add_friend_out"
    @add_friend_resp "add_friend_resp"

    @invit_opened "invit_opened"

    @group_new "group_new"
    @group_update "group_update"
    @add_group_in "add_group_in"
    @add_group_out "add_group_out"
    @add_group_resp "add_group_resp"

    # SQLs
    @sql_is_invit_exists "CALL `sp_is_invit_exists`(?, ?);"
    @sql_ongoing_chats "CALL `sp_ongoing_chats`(?);"
    @sql_friends_list "CALL `sp_friends_list`(?);"
    @sql_invitations_list "SELECT * FROM invitations AS a WHERE a.to_id = ? AND a.`status` = 'WAITING'"
    @sql_groups_list "SELECT a.id, a.unique, a.name, a.members, a.admins FROM groups AS a WHERE a.members LIKE (?)"
    @sql_query_chats "SELECT a.id, a.counter_id, a.messages, a.inserted_at, a.read, a.`type` FROM daily_chats AS a WHERE a.id = ?;"
    @sql_get_chat "SELECT a.id FROM daily_chats AS a WHERE DATE(a.inserted_at) = STR_TO_DATE(?, '%Y-%m-%d') AND a.user_id = ? AND a.counter_id = ? AND a.`type` = 'P2P';"
    
    #=================================================================================================
    # Functions related to user connections and presences
    #=================================================================================================
    def join("user_proxy:" <> username, _params, socket) do
        send self(), :after_join

        {_user, updates} = {socket.assigns.user, %Updates{}}
        |> _get_friends_list()
        |> _get_ongoing_chats()
        |> _get_invitations_list()
        |> _get_groups_list()
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

    defp _get_groups_list({user, struct}) do
        user_id = "%#" <> Integer.to_string(user.id) <> "#%"
        %Result{rows: rows} = SQL.query!(Repo, @sql_groups_list, [user_id])
        if rows == [] do
            {user, %Updates{struct | groups: []}}
        else
            {user, %Updates{struct | groups: _parse_groups(rows, [])}}
        end
    end

    defp _parse_groups([], result) do
        result
    end

    defp _parse_groups([h|t], result) do
        [id, unique, name, members, admins] = h
        group = %GroupChat{
            id: id,
            name: name, 
            unique: unique, 
            members: nil, 
            admins: nil
        }
        _parse_groups(t, result ++ [group])
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
        case type do
            @friendship ->
                friend = User |> Repo.get!(from_id)
                nresult = result ++ [%{id: id, from_id: from_id, from_name: friend.name, type: type, status: status, msg: message, opened: opened}]
                _parse_invits(t, nresult)
            @membership ->
                group = Group |> Repo.get!(from_id)
                nresult = result ++ [%{id: id, from_id: from_id, from_name: group.name, type: type, status: status, msg: message, opened: opened}]
                _parse_invits(t, nresult)
        end
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
        [counter_id, id, read, type] = h
        nresult = result ++ [%{id: id, counter_id: counter_id, chats: nil, date: nil, read: read, type: type}]
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

            case _create_update_users_chat(sender, receiver, chat, :sender) do
                {:error, changeset} ->
                    Logger.error(">>> ERROR #{inspect changeset}")
                {mode1, json1} ->
                    cond do
                        mode1 == :p2p_msg_new ->
                            push socket, @p2p_msg_new, json1
                        true ->
                            push socket, @p2p_msg_in, json1
                    end 
            end

            case _create_update_users_chat(receiver, sender, chat, :receiver) do
                {:error, changeset} ->
                    Logger.error(">>> ERROR #{inspect changeset}")
                {mode2, json2} ->
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

            json = %{id: id, counter_id: counter_id, date: _format_date(date_time), chats: raw["chats"], read: 1, type: type}
            {:reply, {:ok, %{"query_chats_resp" => json}}, socket}
        end
    end

    def handle_in(@p2p_msg_read, %{"id" => id}, socket) do
        chat = DailyChat |> Repo.get!(id)
        upd_chat_map = %{read: true}
        upd_chat_cs = DailyChat.create_or_update_p2p_changeset(chat, upd_chat_map)
        case Repo.update(upd_chat_cs) do
            {:ok, _} ->
                :ignore
            {:error, changeset} ->
                Logger.error(">>> ERROR #{inspect changeset}")
        end
        {:noreply, socket}
    end

    defp _create_update_users_chat(user_a, user_b, chat, mode) do
        %Result{rows: rows} = SQL.query!(Repo, @sql_get_chat, [_format_date(:calendar.universal_time), user_a.id, user_b.id])
        if rows == [] do
            # creates new chat for user
            chats = %Chats{chats: [chat]}
            text = Poison.encode!(chats)
            user_a_chat_map = %{read: _parse_read_val(mode), messages: text, type: @chat_p2p, counter_id: user_b.id}
            |> Map.put(:user, user_a)
            user_a_chat_cs = DailyChat.create_or_update_p2p_changeset(%DailyChat{}, user_a_chat_map)
            |> Changeset.put_assoc(:user, user_a)

            case Repo.insert(user_a_chat_cs) do
                {:ok, user_a_chat} ->
                    raw = Poison.decode!(user_a_chat.messages)
                    json = %{id: user_a_chat.id, counter_id: user_b.id, date: _format_date(user_a_chat.inserted_at), 
                        chats: raw["chats"], read: _parse_bool_val(user_a_chat.read), type: @chat_p2p}
                    {:p2p_msg_new, json}
                {:error, changeset} ->
                    {:error, changeset}
            end
        else
            # updates existing chat
            [[id]] = rows
            user_a_chat = DailyChat |> Repo.get!(id)
            old_user_a_chats = Poison.decode!(user_a_chat.messages, as: %Chats{})
            upd_user_a_chat_list = %Chats{chats: old_user_a_chats.chats ++ [chat]}
            text = Poison.encode!(upd_user_a_chat_list)
            upd_user_a_chat_map = %{read: _parse_read_val(mode), messages: text}
            |> Map.put(:user, user_a)

            upd_user_a_chat_cs = DailyChat.create_or_update_p2p_changeset(user_a_chat, upd_user_a_chat_map)
            case Repo.update(upd_user_a_chat_cs) do
                {:ok, upd_user_a_chat} ->
                    %Chat{from: uname, message: message, time: time} = chat
                    nchat = %{"from" => uname, "message" => message, "time" => time}
                    json = %{id: upd_user_a_chat.id, counter_id: user_b.id, date: _format_date(upd_user_a_chat.updated_at), 
                        chats: [nchat], read: _parse_bool_val(upd_user_a_chat.read), type: @chat_p2p}
                    {:p2p_msg_in, json}
                {:error, changeset} ->
                    {:error, changeset}
            end           
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
                    invit_map = %{from_id: sender.id, invit_type: @friendship, invit_msg: message, status: @waiting}
                    |> Map.put(:to, receiver)
                    invit_cs = Invitation.create_or_update_changeset(%Invitation{}, invit_map)
                    |> Changeset.put_assoc(:to, receiver)
                    case Repo.insert(invit_cs) do
                        {:ok, invit} ->
                            online? = _is_friend_online?(receiver.username)
                            cond do
                                online? == true ->
                                    # Send friend request to online invitee
                                    ol_friend = OnlineUsersDb.select(receiver.username)
                                    json = %{id: invit.id, from_id: invit.from_id, from_name: sender.name, 
                                        type: invit.invit_type, status: invit.status, msg: message}
                                    send ol_friend.pid, {:add_friend_in, json}
                                true ->
                                    :ignore
                            end
                        {:error, changeset} ->
                            Logger.error(">>> ERROR #{inspect changeset}")
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
        |> Repo.preload(:to)

        user_a = Repo.get(User, invit.from_id)
        user_b = invit.to
        cond do
            resp == @accepted ->
                upd_invit_cs = Invitation.create_or_update_changeset(invit, %{status: @accepted})
                case Repo.update(upd_invit_cs) do
                    {:ok, _} ->
                        rel_map = %{tags: invit.invit_type}
                        |> Map.put(:user_a, user_a)
                        |> Map.put(:user_b, user_b)

                        rel_cs = Relation.create_changeset(%Relation{}, rel_map)
                        |> Changeset.put_assoc(:user_a, user_a)
                        |> Changeset.put_assoc(:user_b, user_b)
                        case Repo.insert(rel_cs) do
                            {:ok, _} ->
                                :ignore
                            {:error, changeset} ->
                                Logger.error(">>> ERROR #{inspect changeset}")
                        end

                        json1 = %{
                            id: user_a.id, 
                            username: user_a.username, 
                            name: user_a.name, 
                            online: _is_friend_online?(user_a.username)
                        }
                        # Send new friend data back to acceptor
                        push socket, @friend_new, json1

                        online? = _is_friend_online?(user_a.username)
                        cond do
                            online? == true ->
                                # Inform inviter of a new friend
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
                    {:error, changeset} ->
                        Logger.error(">>> ERROR #{inspect changeset}")
                end
            true ->
                _reject_or_ignore_invit(invit, resp)
        end
        {:noreply, socket}
    end

    #=================================================================================================
    # Functions related to group
    #=================================================================================================
    def handle_info({:add_group_in, invit}, socket) do
        push socket, @add_group_in, invit
        {:noreply, socket}
    end

    def handle_info({:group_update, group}, socket) do
        push socket, @group_update, group
        {:noreply, socket}
    end

    def handle_in(@add_group_out, %{"name" => name, "members" => friends}, socket) do
        admin = socket.assigns.user
        admins = "#" <> Integer.to_string(admin.id) <> "#"
        members = "#" <> Integer.to_string(admin.id) <> "#"

        group_map = %{name: name, admins: admins, members: members}
        group_cs = Group.create_or_update_changeset(%Group{}, group_map)
        case Repo.insert(group_cs) do
            {:ok, group} ->
                friends 
                |> Enum.map(fn(x) -> Repo.get(User, String.to_integer(x)) end)
                |> Enum.each(fn(receiver) ->
                    invit_map = %{from_id: group.id, invit_type: @membership, invit_msg: nil, status: @waiting} 
                    |> Map.put(:to, receiver)
                    invit_cs = Invitation.create_or_update_changeset(%Invitation{}, invit_map)
                    |> Changeset.put_assoc(:to, receiver)
                    case Repo.insert(invit_cs) do
                        {:ok, invit} ->
                            online? = _is_friend_online?(receiver.username)
                            cond do
                                online? == true ->
                                    # Send membership invitation to online invitee
                                    ol_friend = OnlineUsersDb.select(receiver.username)
                                    json = %{id: invit.id, from_id: invit.from_id, from_name: group.name, 
                                        type: invit.invit_type, status: invit.status, msg: nil}
                                    send ol_friend.pid, {:add_group_in, json}
                                true ->
                                    :ignore
                            end
                        {:error, changeset} ->
                            Logger.error(">>> ERROR #{inspect changeset}")
                    end
                end)

                # Send new group to group creator
                group_new = %GroupChat{
                    name: group.name, 
                    unique: group.unique, 
                    members: _parse_users(String.split(group.members, ",")), 
                    admins: _parse_users(String.split(group.admins, ","))
                }
                push socket, @group_new, group_new
            {:error, changeset} ->
                Logger.error(">>> ERROR #{inspect changeset}")
        end
        {:noreply, socket}
    end

    def handle_in(@add_group_resp, %{"id" => id, "resp" => resp}, socket) do
        invit = Invitation 
        |> Repo.get(id)
        |> Repo.preload(:to)

        group = Repo.get(Group, invit.from_id)
        user = invit.to
        cond do
            resp == @accepted ->
                upd_invit_cs = Invitation.create_or_update_changeset(invit, %{status: @accepted})
                case Repo.update(upd_invit_cs) do
                    {:ok, _} ->
                        members = group.members <> ",#" <> Integer.to_string(user.id) <> "#"
                        upd_group_cs = Group.create_or_update_changeset(group, %{members: members})
                        case Repo.update(upd_group_cs) do
                            {:ok, upd_group} ->
                                group_upd = %GroupChat{
                                    name: upd_group.name, 
                                    unique: upd_group.unique, 
                                    members: _parse_users(String.split(upd_group.members, ",")), 
                                    admins: _parse_users(String.split(upd_group.admins, ","))
                                }
                                # Send new group data back to acceptor
                                push socket, @group_new, group_upd

                                # Inform other group members whose online regarding changing in group membership
                                Enum.each(group_upd.members, fn(member) -> 
                                    online? = _is_friend_online?(member.username)
                                    cond do
                                        online? == true ->
                                            ol_friend = OnlineUsersDb.select(member.username)
                                            send ol_friend.pid, {:group_update, group_upd}
                                        true ->
                                            :ignore
                                    end
                                end)
                            {:error, changeset} ->
                                Logger.error(">>> ERROR #{inspect changeset}")
                        end
                    {:error, changeset} ->
                        Logger.error(">>> ERROR #{inspect changeset}")
                end
            true ->
                _reject_or_ignore_invit(invit, resp)
        end
        {:noreply, socket}
    end

    #=================================================================================================
    # Helper functions
    #=================================================================================================
    def handle_in(@invit_opened, %{"id" => id}, socket) do
        invit = Invitation |> Repo.get!(id)
        upd_invit_cs = Invitation.create_or_update_changeset(invit, %{opened: true})
        case Repo.update(upd_invit_cs) do
            {:ok, _} ->
                :ignore
            {:error, changeset} ->
                Logger.error(">>> ERROR #{inspect changeset}")
        end
        {:noreply, socket}
    end

    defp _parse_users(list) do
        Enum.map(list, fn(x) -> 
            id = Regex.replace(~r/#/, x, "")
            String.to_integer(id)
        end) |>
        Enum.map(fn(n) -> 
            user = Repo.get!(User, n)
            %{name: user.name, username: user.username}
        end)
    end

    defp _reject_or_ignore_invit(invit, resp) do
        upd_invit_cs = Invitation.create_or_update_changeset(invit, %{status: resp})
        case Repo.update(upd_invit_cs) do
            {:ok, _} ->
                :ignore
            {:error, changeset} ->
                Logger.error(">>> ERROR #{inspect changeset}")
        end
        :ignore
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