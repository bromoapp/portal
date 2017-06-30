defmodule Portal.WebUserController do
    use Portal.Web, :controller
    alias Portal.User

    plug :scrub_params, "user" when action in [:create]

    def new(conn, _params) do
        changeset = User.new_changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
        changeset = User.create_changeset(%User{}, user_params)
        if changeset.valid? do
            case Repo.insert(changeset) do
                {:ok, user} ->
                    conn
                    |> login(user)
                    |> redirect(to: page_path(conn, :lobby))
                {:error, changeset} ->
                    render(conn, "new.html", changeset: changeset)
            end
        else
            render(conn, "new.html", changeset: changeset)
        end
    end

end