defmodule Portal.Private do
    use Portal.Web, :channel
    import Portal.OnlineUsersDb, only: [select: 1, insert: 1, delete: 1, update: 1]
    alias Portal.Presence
    alias Portal.OnlineUser
    require Logger

    def join("private:" <> username, _params, socket) do
        send self(), :after_join
        {:ok, socket}
    end
    
    def terminate(_reason, socket) do
        Logger.info(">>> USER LEFT: #{inspect socket.assigns.user.username}")        
        
        # Delete user data from online users db
        user = socket.assigns.user
        delete(user.username)

        {:noreply, socket}
    end

    def handle_info(:after_join, socket) do
        Logger.info(">>> USER JOIN: #{inspect socket.assigns.user.username}")
        
        # Tracking user with presence
        user = socket.assigns.user
        Presence.track(socket, user.username, %{
            name: user.name,
            online_at: :os.system_time(:milli_seconds)
        })
        
        # Insert user data to online users db
        ol_user = %OnlineUser{
            name: user.name,
            username: user.username,
            node: node(),
            pid: self()
        }
        insert(ol_user)
        {:noreply, socket}
    end
    
end