defmodule Portal.ApiUserController do
    use Portal.Web, :controller

    alias Portal.User

    require Logger

    def show(conn, %{"id" => id}) do
        try do
            user = Repo.get!(User, id)
            render(conn, "user.json", user: user)
        rescue
            Ecto.NoResultsError ->
                render(conn, "error.json", error: "record not found!")
        end
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
        try do
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
        rescue
            Ecto.NoResultsError ->
                render(conn, "error.json", error: "record not found!")
        end
    end
end