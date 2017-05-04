defmodule Portal.SessionController do
    use Portal.Web, :controller
    
    plug :authorized when action in [:new]

    alias Portal.Repo
    alias Portal.User

    def new(conn, _params) do
        render(conn, "new.html", [])
    end

    def create(conn, %{"session" => %{"username" => uname, "password" => pass}}) do
        user = Repo.get_by(User, username: uname)
        passwd = :crypto.hash(:sha256, pass) |> Base.encode16
        cond do
            user && passwd == user.password_hash ->
                conn
                |> login(user)
                |> redirect(to: page_path(conn, :lobby))
            true ->
                conn
                |> put_flash(:error, "Invalid username/password combination!")
                |> redirect(to: session_path(conn, :new)) 
        end
    end

    def delete(conn, _args) do
        user = Guardian.Plug.current_resource(conn)
        conn
        |> logout(user)
        |> put_flash(:info, "See you later #{user.name}")
        |> redirect(to: page_path(conn, :home))
    end
end