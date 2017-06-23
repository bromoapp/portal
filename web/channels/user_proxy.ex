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
        Logger.info(">>> USER LEFT FROM PROXY: #{inspect user.username}")        
        
        # 1. Inform user's friends that he/she is offline
        _get_friends(user) |>
            Enum.each(fn(friend) ->
                cond do
                    friend.online == true ->
                        ol_user = OnlineUsersDb.select(friend.username)
                        cond do
                            ol_user != nil ->
                                :ok
                                # Inform user's friends that he/she is offline
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
        Logger.info(">>> USER JOIN: #{inspect socket.assigns.user.username}")
        
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
                        ol_user = OnlineUsersDb.select(friend.username)
                        cond do
                            ol_user != nil ->
                                :ok
                                # Informs user's friends that he/she is online
                            true ->
                                :ignore
                        end
                    true ->
                        :ignore
                end
            end)

        {:noreply, socket}
    end

    def handle_info(:online_friend, socket) do
        
    end

    defp _get_friends_status_updates(user) do
        # Query user's friends data and push it to user
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