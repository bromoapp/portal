defmodule Portal.Shared do
    use Portal.Web, :channel
    require Logger

    def join("shared:" <> unique, _params, socket) do
        Logger.info(">>> JOIN USER: #{inspect socket.assigns.user}; PID = #{inspect self()}")
        send self(), :after_join
        {:ok, socket}
    end

    def handle_info(:after_join, socket) do
        Presence.track(socket, socket.assigns.user, %{
            online_at: :os.system_time(:milli_seconds)
        })
        push socket, "presence_state", Presence.list(socket)
        {:noreply, socket}
    end
end