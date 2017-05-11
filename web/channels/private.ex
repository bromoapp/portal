defmodule Portal.Private do
    use Portal.Web, :channel
    alias Portal.UserPresence
    alias Portal.Relation
    alias Portal.User
    require Logger

    def join("private:" <> username, _params, socket) do
        send self(), :after_join
        {:ok, socket}
    end
    
    def terminate(_reason, socket) do
        Logger.info(">>> USER LEFT: #{inspect socket.assigns.user.username}")        
        
        # Delete user from db
        user = socket.assigns.user
        delete(user.username)
        {:noreply, socket}
    end

    def handle_info(:after_join, socket) do
        Logger.info(">>> USER JOIN: #{inspect socket.assigns.user.username}")
        
        # Tracking user with presence
        user = socket.assigns.user
        UserPresence.track(socket, user.username, %{
            name: user.name,
            online_at: :os.system_time(:milli_seconds)
        })

        # Insert user to db
        ol_user = %OnlineUser{
            name: user.name,
            username: user.username,
            node: node(),
            pid: self()
        }
        insert(ol_user)

        # Initiate periodik checks on user's friends
        :timer.send_interval(10_000, :update_user)
        
        {:noreply, socket}
    end

    def handle_info(:update_user, socket) do
        # Query user's friends from db
        user = socket.assigns.user
        friends = _get_friends(user)
        
        Logger.info(">>> RECS = #{inspect friends}")
        {:noreply, socket}
    end

    defp _get_friends(user) do
        sql_1 = "SELECT a.user_b_id AS 'id' FROM relations AS a WHERE a.user_a_id = ?"
        %Mariaex.Result{rows: rows1} = Ecto.Adapters.SQL.query!(Repo, sql_1, [user.id])
        friends = _parse_users(rows1, [])
        
        sql_2 = "SELECT a.user_a_id AS 'id' FROM relations AS a WHERE a.user_b_id = ?"
        %Mariaex.Result{rows: rows2} = Ecto.Adapters.SQL.query!(Repo, sql_2, [user.id])
        _parse_users(rows2, friends)      
    end

    defp _parse_users([], result) do
        result
    end

    defp _parse_users([[id]|t], result) do
        user = Repo.get(User, id)
        n_result = result ++ [%{id: user.id, username: user.username, name: user.name}]
        _parse_users(t, n_result)
    end
end