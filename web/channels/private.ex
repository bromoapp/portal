defmodule Portal.Private do
    use Portal.Web, :channel
    import Portal.OnlineUsersDb, only: [insert: 1, delete: 1, select: 1, update: 1]
    alias Portal.OnlineUser
    require Logger

    def join("private:" <> username, _params, socket) do
        Logger.info(">>> JOIN USER: #{inspect socket.assigns.user}; PID = #{inspect self()}")
        send self(), {:after_join, socket.assigns.user}
        {:ok, socket}
    end

    def terminate(_reason, socket) do
        Logger.info(">>> LEAVE USER: #{inspect socket.assigns.user}; PID = #{inspect self()}")
        {:ok, socket}
    end

    def handle_info({:after_join, user}, socket) do
        online_user = %OnlineUser{name: user.name, username: user.username, node: node(), pid: self()}
        :ok = insert(online_user)
        {:noreply, socket}
    end
end