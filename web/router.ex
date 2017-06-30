defmodule Portal.Router do
    use Portal.Web, :router

    pipeline :browser do
        plug :accepts, ["html"]
        plug :fetch_session
        plug :fetch_flash
        plug :protect_from_forgery
        plug :put_secure_browser_headers
    end

    pipeline :api do
        plug :accepts, ["json"]
        plug :fetch_session
        plug :fetch_flash
    end

    pipeline :authenticated do
        plug Guardian.Plug.VerifySession
        plug Guardian.Plug.LoadResource
        plug Portal.SessionHelper
    end

    scope "/", Portal do
        pipe_through :browser # Use the default browser stack

        get "/", PageController, :to_home
    end

    scope "/web", Portal do
        pipe_through [:browser, :authenticated]

        get "/", PageController, :home
        get "/lobby", PageController, :lobby
        resources "/sessions", SessionController, only: [:new, :create, :delete]
        resources "/users", WebUserController, only: [:new, :create, :delete]
    end

    scope "/api", Portal do
        pipe_through [:api, :authenticated]

        post "/chats/latest", ApiChatController, :latest
        post "/chats/ongoing", ApiChatController, :ongoing
        get "/unauthorized", ApiUnauthorizedController, :show
        get "/user/show", ApiUserController, :show

        put "/user/update", ApiUserController, :update
    end

end
