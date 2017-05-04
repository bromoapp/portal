defmodule Portal.Lobby do
    use Portal.Web, :channel
    
    alias Portal.Presence

    require Logger

    def join("channel:lobby", _params, socket) do
        Logger.info(">>> JOIN USER: #{inspect socket.assigns.user}; PID = #{inspect self()}")
        send self(), :after_join
        {:ok, socket}
    end

    def handle_info(:after_join, socket) do
        Presence.track(socket, socket.assigns.user, %{online_at: :os.system_time(:milli_seconds)})
        {:noreply, socket}
    end
    
    def handle_in("query:", message, socket) do
        Logger.info(">>> MESSAGE = #{inspect message}")
        
        {:noreply, socket}
    end
end