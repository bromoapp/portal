defmodule Portal.UserProxy do
    use Portal.Web, :channel
    alias Portal.ProxyPresence
    alias Portal.Relation
    alias Portal.Updates
    alias Portal.User
    require Logger

    def join("user_proxy:" <> username, _params, socket) do
        send self(), :after_join
        {:ok, socket}
    end
    
    def terminate(_reason, socket) do
        user = socket.assigns.user
        Logger.info(">>> USER LEFT: #{inspect user.username} IN NODE: #{inspect node()}")
        
        # 1. Inform user's friends that he/she is offline
        _get_friends(user) |>
            Enum.each(fn(friend) ->
                cond do
                    friend.online == true ->
                        ol_friend = OnlineUsersDb.select(friend.username)
                        cond do
                            ol_friend != nil ->
                                Logger.info(">>> TRY TO INFORM #{inspect ol_friend.username} AT #{inspect ol_friend.node}")
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

        # 2. Insert user to db
        ol_user = %OnlineUser{
            name: user.name,
            username: user.username,
            node: node(),
            pid: self()
        }
        Logger.info(">>> USER JOIN: #{inspect ol_user.username} IN NODE: #{inspect ol_user.node}")

        OnlineUsersDb.insert(ol_user)

        # 3. Send updates for user on joined
        updates = socket.assigns.user
            |> _get_friends_status_updates()
        
        push socket, "initial_updates", updates
        
        # 4. Informs user's friends that he/she is online
        updates.friends |>
            Enum.each(fn(friend) ->
                cond do
                    friend.online == true ->
                        ol_friend = OnlineUsersDb.select(friend.username)
                        cond do
                            ol_friend != nil ->
                                Logger.info(">>> TRY TO INFORM #{inspect ol_friend.username} AT #{inspect ol_friend.node}")
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
        user = socket.assigns.user
        Logger.info(">>> #{inspect user.username} GOT ONLINE FRIEND: #{inspect friend.username}")
        push socket, "friend_online", %{id: friend.id, username: friend.username, name: friend.name, online: true}
        {:noreply, socket}
    end

    def handle_info({:friend_offline, friend}, socket) do
        user = socket.assigns.user
        Logger.info(">>> #{inspect user.username} GOT OFFLINE FRIEND: #{inspect friend.username}")
        push socket, "friend_offline", %{id: friend.id, username: friend.username, name: friend.name, online: false}
        {:noreply, socket}
    end

    defp _get_friends_status_updates(user) do
        friends = _get_friends(user)
        %Updates{friends: friends}
    end

    defp _get_friends(user) do
        sql_1 = "SELECT a.user_b_id AS 'id' FROM relations AS a WHERE a.user_a_id = ?"
        %Mariaex.Result{rows: rows1} = Ecto.Adapters.SQL.query!(Repo, sql_1, [user.id])
        friends = _parse_friends(rows1, [])

        sql_2 = "SELECT a.user_a_id AS 'id' FROM relations AS a WHERE a.user_b_id = ?"
        %Mariaex.Result{rows: rows2} = Ecto.Adapters.SQL.query!(Repo, sql_2, [user.id])
        _parse_friends(rows2, friends)
    end

    defp _parse_friends([], result) do
        result
    end

    defp _parse_friends([[id]|t], result) do
        user = Repo.get(User, id)
        ol_user = OnlineUsersDb.select(user.username)
        cond do
            ol_user == nil ->
                n_result = result ++ [%{id: user.id, username: user.username, name: user.name, online: false}]
                _parse_friends(t, n_result)
            true ->
                n_result = result ++ [%{id: user.id, username: user.username, name: user.name, online: true}]
                _parse_friends(t, n_result)
        end
    end
end