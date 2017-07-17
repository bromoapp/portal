defmodule Portal.AuthController do
    use Portal.Web, :controller
    plug Ueberauth
    require Logger

    def new(conn, params) do
        Logger.info(">>> CODE: #{inspect params}")
        render conn, "home.html"
    end

    def request() do
        
    end

end