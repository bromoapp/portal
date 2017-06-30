defmodule Portal.ApiChatController do
    use Portal.Web, :controller

    plug :is_api_req_authorized when action in [:latest, :chats_on]

    def latest(conn, %{"friend" => friend_uname}) do
        render(conn, "chats.json", nil)
    end

    def chats_on(conn, %{"friend" => friend_uname, "date" => date}) do
        render(conn, "chats.json", nil)
    end
end