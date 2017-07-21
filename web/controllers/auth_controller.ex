defmodule Portal.AuthController do
    use Portal.Web, :controller
    require Logger
    alias Portal.GoogleOauth2

    def new(conn, %{"provider" => privider}) do
        redirect conn, external: _get_auth_url(privider)
    end

    def create(conn, %{"code" => code, "provider" => provider}) do
        token = _acquire_token(provider, code)
        Logger.info(">>> TOKEN: #{inspect token}")
        redirect(conn, to: page_path(conn, :home))
    end

    defp _get_auth_url("google") do
        provider = Application.get_env(:portal, :google)
        GoogleOauth2.auth_url provider
    end

    defp _acquire_token("google", code) do
        GoogleOauth2.acquire_token(code)
    end
end