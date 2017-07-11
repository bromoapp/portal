defmodule Portal.SessionHelper do
    import Phoenix.Controller
    import Plug.Conn
    import Guardian.Plug
    alias Portal.Router.Helpers

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

    def login(conn, user) do
        conn
            |> sign_in_user(user)
            |> configure_session(renew: true)
    end

    def logout(conn) do
        # Invalidate user session
        conn
            |> sign_out()
            |> configure_session(drop: true)
    end

    def is_web_req_authorized?(conn, _opts) do
        if current_resource(conn) do
            conn
        else
            conn
                |> configure_session(drop: true)
                |> redirect(to: Helpers.page_path(conn, :to_home))
                |> halt
        end
    end

    def is_api_req_authorized?(conn, _opts) do
        if current_resource(conn) do
            conn
        else
            conn
                |> configure_session(drop: true)
                |> redirect(to: Helpers.api_unauthorized_path(conn, :show))
                |> halt
        end
    end

    defp sign_in_user(conn, user) do
        # Add access_token to Plug.Conn so it will accessible from view
        token = Phoenix.Token.sign(conn, "portal_salt", user)

        conn
            |> assign(:current_user, user)
            |> sign_in(user)
            |> assign(:access_token, token)
    end
end