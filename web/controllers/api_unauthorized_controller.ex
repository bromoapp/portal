defmodule Portal.ApiUnauthorizedController do
    use Portal.Web, :controller

    def show(conn, _args) do
         render(conn, "error.json", error: "Unauthorized access!")
    end
end