defmodule Portal.Private do
    use Portal.Web, :channel
    alias Portal.Presence
    require Logger

    def join("ch:private:" <> username, _params, socket) do
        send self(), :after_join
        {:ok, socket}
    end
    
    def terminate(_reason, socket) do
        send self(), :after_quit
        {:ok, socket}
    end

    def handle_info(:after_join, socket) do
        Logger.info(">>> USER JOIN: #{inspect socket.assigns.user.username}")   
        user = socket.assigns.user     
        Presence.track(socket, user, %{
            online_at: :os.system_time(:milli_seconds)
        })
        {:noreply, socket}
    end

    def handle_info(:after_quit, socket) do
        Logger.info(">>> USER LEFT: #{inspect socket.assigns.user.username}")        
        {:noreply, socket}
    end
    
end