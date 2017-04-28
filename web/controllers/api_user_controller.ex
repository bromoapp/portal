defmodule Portal.ApiUserController do
    use Portal.Web, :controller

    def show(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        render(conn, "show.json", user: user)
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
        user = Repo.get!(User, id)
        changeset = User.changeset(user, user_params)
  
        case Repo.update(changeset) do
        {:ok, user} ->
            render(conn, "show.json", user: user)
        {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Portal.ChangesetView, "error.json", changeset: changeset)
        end
    end
end