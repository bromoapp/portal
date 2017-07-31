defmodule Portal.Group do
    use Portal.Web, :model

    @default_status "PASSIVE"

    schema "groups" do
        field :name, :string
        field :members, :string
        field :admins, :string
        field :status, :string, default: @default_status

        timestamps()
    end

    def create_or_update_changeset(struct, params) do
        struct
        |> cast(params, [:name, :members, :admins, :status])
        |> validate_required([:name, :admins])
    end
end