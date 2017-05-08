defmodule Portal.Shared do
    use Portal.Web, :channel
    require Logger

    def join("shared:" <> username, _params, socket) do
        Logger.info(">>> JOIN USER: #{inspect socket.assigns.user}; PID = #{inspect self()}")
        {:ok, socket}
    end
end