defmodule Portal.UserGroup do
    use Portal.Web, :channel
    require Logger

    def join("user_group:" <> unique, _params, socket) do
        send self(), "after_join"
        {:ok, socket}
    end

    def terminate(_reason, socket) do
        Logger.info(">>> USER LEFT FROM GROUP: #{inspect socket.assigns.user.username}")
        {:noreply, socket}
    end

    def handle_info("after_join", socket) do
        {:noreply, socket}
    end
end