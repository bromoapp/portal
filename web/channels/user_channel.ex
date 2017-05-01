defmodule Portal.UserChannel do
    use Portal.Web, :channel

    def join("room:" <> username, params, socket) do
        {:ok, assign(socket, :username, username)}
    end
end