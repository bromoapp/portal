defmodule Portal.Group do
    use Portal.Web, :model

    schema "groups" do
        field :name, :string
        field :members, :string
        field :admins, :string

        timestamps()
    end
end