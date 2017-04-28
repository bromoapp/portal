defmodule Portal.WebUserController do
    use Portal.Web, :controller

    alias Portal.User

    def create(conn, %{"user" => user_params}) do
        changeset = User.register_changeset(%User{}, user_params)
    end

    def show(conn, %{"id" => id}) do
        
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
        
    end

    def delete(conn, %{"id" => id}) do
        
    end
end