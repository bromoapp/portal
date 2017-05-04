defmodule Portal.Room do
    use Portal.Web, :model

    schema "rooms" do
        field :name, :string
        field :mode, :string

        has_many :members, Portal.Member

        timestamps()
    end

    @doc """
    Builds a changeset based on the `struct` and `params`.
    """
    def changeset(struct, params \\ :invalid) do
        struct
        |> cast(params, [:name, :mode])
        |> validate_required([:name, :mode])
    end
end
