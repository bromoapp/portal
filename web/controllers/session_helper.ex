defmodule Portal.SessionHelper do

    def login(conn, user) do
        conn
        |> Guardian.Plug.sign_in(user)
    end

    def logout(conn, user) do
        conn
        |> Guardian.Plug.sign_out()
    end

end