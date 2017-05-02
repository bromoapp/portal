defmodule Portal.UserChannel do
    use Portal.Web, :channel

    alias Portal.OnlineUser

    def join("room:" <> username, params, socket) do
        # Updates room_pid field's value in user object in OnlineUsersServer
        user = get_user(String.to_atom(username))
        |> Map.merge(%{room_pid: self()})
        upd_user(String.to_atom(username), user)

        {:ok, assign(socket, :current_user, user)}
    end
end