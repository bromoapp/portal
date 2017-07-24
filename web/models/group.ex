defmodule Portal.Group do
    use Portal.Web, :model

    schema "groups" do
        field :name, :string
        field :members, :string
        field :admins, :string

        timestamps()
    end

    def create_or_update_changeset(struct, params) do
        struct
        |> cast(params, [:name, :members, :admins])
        |> validate_required([:name, :members, :admins])
        |> foreign_key_constraint(:creator)
    end
end