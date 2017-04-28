defmodule Portal.WebUserController do
    use Portal.Web, :controller

    alias Portal.User

    def new(conn, _params) do
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
        changeset = User.register_changeset(%User{}, user_params)

        case Repo.insert(changeset) do
            {:ok, user} ->
                conn
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end

    def delete(conn, %{"id" => id}) do
        
    end
end