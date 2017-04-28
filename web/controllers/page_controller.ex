defmodule Portal.PageController do
    use Portal.Web, :controller

    def to_home(conn, _params) do
        conn
        |> redirect(to: page_path(conn, :home))
    end

    def home(conn, _params) do
        render conn, "home.html"
    end
end
