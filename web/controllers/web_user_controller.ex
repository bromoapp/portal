defmodule Portal.WebUserController do
    use Portal.Web, :controller
    alias Portal.User
    alias Portal.SessionHelper

    plug :authorized when action in [:new]
    plug :scrub_params, "user" when action in [:create]

    def new(conn, _params) do
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
        changeset = User.create_changeset(%User{}, user_params)

        case Repo.insert(changeset) do
            {:ok, user} ->
                conn
                |> SessionHelper.login(user)
                |> redirect(to: page_path(conn, :lobby))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end

end