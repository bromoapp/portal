defmodule Portal.Member do
    use Portal.Web, :model

    schema "members" do
        field :role, :string

        belongs_to :user, Portal.User
        belongs_to :room, Portal.Room

        timestamps()
    end

    @doc """
    Builds a changeset based on the `struct` and `params`.
    """
    def changeset(struct, params \\ :invalid) do
        struct
        |> cast(params, [:role])
        |> cast_assoc(:user, required: true)
        |> cast_assoc(:room, required: true)
        |> validate_required([:role])
    end
end
