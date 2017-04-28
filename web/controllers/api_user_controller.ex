defmodule Portal.ApiUserController do
    use Portal.Web, :controller

    alias Portal.User

    def show(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        render(conn, "user.json", user: user)
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
        user = Repo.get!(User, id)
        changeset = User.update_changeset(user, user_params)
  
        case Repo.update(changeset) do
        {:ok, user} ->
            render(conn, "user.json", user: user)
        {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Portal.ChangesetView, "error.json", changeset: changeset)
        end
    end
end