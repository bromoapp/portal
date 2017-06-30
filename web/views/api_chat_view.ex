defmodule Portal.ApiChatView do
    use Portal.Web, :view

    def render("chats.json", %{chats: chats}) do
        %{
            date: "nil",
            chats: []
        }
    end

    def render("error.json", %{error: message}) do
        %{
            error: message
        }
    end
end