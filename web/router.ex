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

    pipeline :app do
        plug :accepts, ["json"]
        plug :fetch_session
        plug :fetch_flash
    end

    scope "/", Portal do
        pipe_through :browser # Use the default browser stack

        get "/", PageController, :to_home
    end

    scope "/web", Portal do
        pipe_through :browser

        get "/", PageController, :home
        resources "/sessions", WebSessionController, only: [:new, :create, :delete]
        resources "/users", WebUserController, only: [:new, :create, :delete]
    end

    scope "/api", Portal do
        pipe_through :api

        resources "/users", ApiUserController, only: [:show, :update]
    end

    scope "/app", Portal do
        pipe_through :app

        resources "/sessions", AppSessionController, only: [:create, :delete]
        resources "/users", AppUserController, only: [:create, :show, :update, :delete]
    end

end
