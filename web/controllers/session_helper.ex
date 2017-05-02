defmodule Portal.SessionHelper do
    import Plug.Conn

    alias Portal.OnlineUsersServer
    alias Portal.OnlineUser
    
    def login(conn, user) do
        # Register user into OnlineUsersServer
        oluser = %OnlineUser{
            name: user.name,
            username: user.username,
            node: node()
        }
        OnlineUsersServer.reg_user(String.to_atom(user.username), oluser)

        # Add access_token to Plug.Conn so it will accessible from view
        token = Phoenix.Token.sign(conn, "portal_salt", user.id)
        conn
        |> Guardian.Plug.sign_in(user)
        |> assign(:access_token, token)
    end

    def logout(conn, user) do
        # Unregister user from OnlineUsersServer
        OnlineUsersServer.unreg_user(String.to_atom(user.username))

        # Invalidate user session
        conn
        |> Guardian.Plug.sign_out()
        |> configure_session(drop: true)
    end

end