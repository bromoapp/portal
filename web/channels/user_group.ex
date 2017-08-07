defmodule Portal.UserGroup do
    use Portal.Web, :channel
    alias Portal.GroupPresence
    require Logger

    @online_members "online_members"
    @p2g_msg_new "p2g_msg_new"
    @p2g_msg_in "p2g_msg_in"

    def join("user_group:" <> unique, _params, socket) do
        user = socket.assigns.user
        Logger.info(">>> JOINED TO #{inspect unique} USER: #{inspect user.name}")
        send self(), :after_join
        {:ok, socket}
    end

    def terminate(_reason, socket) do
        user = socket.assigns.user
        GroupPresence.untrack(socket, user.username)
        {:noreply, socket}
    end

    def handle_info(:after_join, socket) do
        user = socket.assigns.user

        GroupPresence.track(socket, user.username, %{name: user.name, username: user.username})
        push socket, @online_members, GroupPresence.list(socket)
        {:noreply, socket}
    end
end