defmodule Portal.PageController do
    use Portal.Web, :controller
    require Logger

    plug :is_web_req_authorized when action in [:home]

    def to_home(conn, _params) do
        redirect(conn, to: page_path(conn, :home))
    end

    def home(conn, _params) do
        render conn, "home.html"
    end

    def lobby(conn, _params) do
        cond do
            conn.assigns.current_user != nil ->
                render conn, "lobby.html"
            true ->
                redirect(conn, to: page_path(conn, :home))
        end
    end
end
