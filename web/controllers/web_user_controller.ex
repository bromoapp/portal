defmodule Portal.WebUserController do
    use Portal.Web, :controller

    alias Portal.User

    def new(conn, _params) do
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
        
    end

    def delete(conn, %{"id" => id}) do
        
    end
end