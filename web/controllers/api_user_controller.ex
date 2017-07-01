defmodule Portal.ApiUserController do
    use Portal.Web, :controller
    alias Portal.User

    plug :is_api_req_authorized?
    
    def show(conn, _params) do
        user = conn.assigns.current_user
        try do
            loaded_user = Repo.get!(User, user.id)
            render(conn, "user.json", user: loaded_user)
        rescue
            Ecto.NoResultsError ->
                render(conn, "error.json", error: "record not found!")
        end
    end

    def update(conn, %{"user" => user_params}) do
        user = conn.assigns.current_user
        try do
            loaded_user = Repo.get!(User, user.id)
            changeset = User.update_changeset(user, user_params)
    
            case Repo.update(changeset) do
                {:ok, loaded_user} ->
                    render(conn, "user.json", user: loaded_user)
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