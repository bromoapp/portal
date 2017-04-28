defmodule Portal.AppUserView do
    use Portal.Web, :view
    require Logger

    def render("show.json", %{user: user}) do
        %{
            id: user.id,
            name: user.name, 
            username: user.username,
            created: user.inserted_at
        }
    end

end