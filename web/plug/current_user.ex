defmodule Portal.CurrentUser do
    import Phoenix.Controller
    import Plug.Conn
    import Guardian.Plug

    alias Portal.Router.Helpers
    alias Portal.OnlineUsersServer
    alias Portal.OnlineUser

    def init(opts) do
        opts
    end

    def call(conn, _opts) do
        current_user = current_resource(conn)
        cond do
            current_user != nil ->
                sign_in_user(conn, current_user)
            true ->
                conn
                |> assign(:current_user, nil)
                |> assign(:access_token, nil)
        end
    end

    def authorized(conn, _opts) do
        if conn.assigns.current_user do
            conn
            |> redirect(to: Helpers.page_path(conn, :lobby))
        else
            conn
        end
    end

    def login(conn, user) do
        # Register user into OnlineUsersServer
        oluser = %OnlineUser{
            name: user.name,
            username: user.username,
            node: node()
        }
        OnlineUsersServer.reg_user(String.to_atom(user.username), oluser)
        
        conn
        |> sign_in_user(user)
        |> Guardian.Plug.sign_in(user)
        |> configure_session(renew: true)
    end

    def logout(conn, user) do
        # Unregister user from OnlineUsersServer
        OnlineUsersServer.unreg_user(String.to_atom(user.username))

        # Invalidate user session
        conn
        |> Guardian.Plug.sign_out()
        |> configure_session(drop: true)
    end

    defp sign_in_user(conn, user) do
        # Add access_token to Plug.Conn so it will accessible from view
        token = Phoenix.Token.sign(conn, "portal_salt", user.id)

        conn
        |> assign(:current_user, user)
        |> Guardian.Plug.sign_in(user)
        |> assign(:access_token, token)
    end
end