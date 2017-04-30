defmodule Portal.CurrentUser do
    import Phoenix.Controller
    import Plug.Conn
    import Guardian.Plug

    alias Portal.Router.Helpers

    def init(opts) do
        opts
    end

    def call(conn, _opts) do
        current_user = current_resource(conn)
        assign(conn, :current_user, current_user)
    end

    def authorized(conn, _opts) do
        if conn.assigns.current_user do
            conn
            |> redirect(to: Helpers.page_path(conn, :lobby))
        else
            conn
        end
    end
end