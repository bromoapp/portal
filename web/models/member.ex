defmodule Portal.Member do
    use Portal.Web, :model

    schema "members" do
        field :name, :string
        field :role, :string
        belongs_to :user, Portal.User
        belongs_to :room, Portal.Room

        timestamps()
    end

    @doc """
    Builds a changeset based on the `struct` and `params`.
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :role])
        |> validate_required([:name, :role])
    end
end
