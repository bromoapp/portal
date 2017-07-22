defmodule Portal.SessionController do
    use Portal.Web, :controller

    plug :is_web_req_authorized? when action in [:delete]

    def delete(conn, _args) do
        user = Guardian.Plug.current_resource(conn)
        conn
        |> logout()
        |> put_flash(:info, "See you later #{user.name}")
        |> redirect(to: page_path(conn, :home))
    end
end