defmodule Portal.Lobby do
    use Portal.Web, :channel
    
    require Logger

    def join("lobby:" <> username, _params, socket) do
        Logger.info(">>> JOIN USER: #{inspect socket.assigns.user}; PID = #{inspect self()}")
        send self(), :after_join
        {:ok, socket}
    end

    def handle_info(:after_join, socket) do
        {:noreply, socket}
    end
    
    def handle_in("stream:video", stream, socket) do
        
        {:noreply, socket}
    end
end