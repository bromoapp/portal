defmodule Portal.UserGroup do
    use Portal.Web, :channel
    alias Portal.GroupPresence
    alias Portal.Updates
    require Logger

    @p2g_msg_out "p2g_msg_out"
    @p2g_msg_new "p2g_msg_new"
    @p2g_msg_in "p2g_msg_in"

    #=================================================================================================
    # Functions related to members connections and presences
    #=================================================================================================
    def join("user_group:" <> unique, _params, socket) do
        send self(), :after_join

        {_user, updates} = {socket.assigns.user, %Updates{}}
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

    defp _get_members_list({user, struct}) do
        {user, %Updates{struct | members: []}}
    end

    defp _get_ongoing_chats({user, struct}) do
        {user, %Updates{struct | chats: []}}
    end

    #=================================================================================================
    # Helper functions
    #=================================================================================================
    defp _parse_unique(topic) do
        [_h, unique] = String.split(topic, ":")
        unique
    end
end