defmodule Portal.Private do
    use Portal.Web, :channel
    alias Portal.Presence
    require Logger

    def join("private:" <> username, _params, socket) do
        Logger.info(">>> JOIN USER: #{inspect socket.assigns.user}; PID = #{inspect self()}")
        {:ok, socket}
    end
end