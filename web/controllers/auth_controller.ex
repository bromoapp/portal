defmodule Portal.AuthController do
    use Portal.Web, :controller
    alias Portal.GoogleOauth2
    alias Portal.User
    require Logger

    def new(conn, %{"provider" => privider}) do
        redirect conn, external: _get_auth_url(privider)
    end

    def create(conn, %{"code" => code, "provider" => provider}) do
        {:ok, token_req_resp} = _acquire_token(provider, code)
        cond do
            token_req_resp["error"] != nil ->
                desc = token_req_resp["error_description"]
                conn
                |> put_flash(:error, desc)
                |> redirect(to: page_path(conn, :home))
            true ->
                {:ok, profile_req_resp} = _acquire_profile(provider, token_req_resp["access_token"])
                username = profile_req_resp["email"]
                name = profile_req_resp["name"]
                pass = profile_req_resp["id"]

                user = Repo.get_by(User, username: username)
                if user == nil do
                    # Creates a new user
                    user_params = %{name: name, username: username, password: pass}
                    changeset = User.create_changeset(%User{}, user_params)
                    if changeset.valid? do
                        case Repo.insert(changeset) do
                            {:ok, user} ->
                                conn
                                |> login(user)
                                |> redirect(to: page_path(conn, :lobby))
                            {:error, changeset} ->
                                conn
                                |> put_flash(:error, changeset)
                                |> redirect(to: page_path(conn, :home))
                        end
                    else
                        conn
                        |> put_flash(:error, changeset)
                        |> redirect(to: page_path(conn, :home))
                    end
                else
                    # Validates newly logged in user
                    passwd = :crypto.hash(:sha256, pass) |> Base.encode16
                    cond do
                        user && passwd == user.password_hash ->
                            conn
                            |> login(user)
                            |> redirect(to: page_path(conn, :lobby))
                        true ->
                            conn
                            |> put_flash(:error, "Unknown user!")
                            |> redirect(to: page_path(conn, :home))
                    end
                end
        end
    end

    defp _get_auth_url("google") do
        provider = Application.get_env(:portal, :google)
        GoogleOauth2.auth_url provider
    end

    defp _acquire_token("google", code) do
        GoogleOauth2.acquire_token(code)
    end

    defp _acquire_profile("google", token) do
        GoogleOauth2.acquire_profile(token)
    end
end