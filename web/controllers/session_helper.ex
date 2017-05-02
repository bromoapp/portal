defmodule Portal.SessionHelper do
    import Plug.Conn

    alias Portal.OnlineUsersServer
    alias Portal.OnlineUser
    
    def login(conn, user) do
        oluser = %OnlineUser{
            name: user.name,
            username: user.username,
            node: node()
        }
        OnlineUsersServer.reg_user(String.to_atom(user.username), oluser)

        token = Phoenix.Token.sign(conn, "portal_salt", user.id)
        conn
        |> Guardian.Plug.sign_in(user)
        |> assign(:access_token, token)
    end

    def logout(conn, user) do
        OnlineUsersServer.unreg_user(String.to_atom(user.username))

        conn
        |> Guardian.Plug.sign_out()
        |> configure_session(drop: true)
    end

end