defmodule Portal.Lobby do
    use Portal.Web, :channel
    
    alias Portal.Presence

    require Logger

    def join("channel:lobby", _params, socket) do
        Logger.info(">>> JOIN USER: #{inspect socket.assigns.user}")
        {:ok, socket}
    end

end