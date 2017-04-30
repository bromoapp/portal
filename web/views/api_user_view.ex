defmodule Portal.ApiUserView do
    use Portal.Web, :view
    require Logger

    def render("user.json", %{user: user}) do
        %{
            id: user.id,
            name: user.name, 
            username: user.username,
            created: user.inserted_at
        }
    end

    def render("error.json", %{error: message}) do
        %{
            error: message
        }
    end

end