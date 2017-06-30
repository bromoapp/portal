defmodule Portal.ApiUnauthorizedView do
    use Portal.Web, :view

    def render("error.json", %{error: message}) do
        %{
            error: message
        }
    end
end