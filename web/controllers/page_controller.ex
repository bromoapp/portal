defmodule Portal.PageController do
    use Portal.Web, :controller

    require Logger

    def to_home(conn, _params) do
        conn
        |> redirect(to: page_path(conn, :home))
    end

    def home(conn, _params) do
        render conn, "home.html"
    end

    def lobby(conn, _params) do
        Logger.info(">>> CON = #{inspect conn}")
        render conn, "lobby.html"
    end
end
