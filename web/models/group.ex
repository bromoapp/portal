defmodule Portal.Group do
    use Portal.Web, :model

    schema "groups" do
        field :unique, :string
        field :name, :string
        field :members, :string
        field :admins, :string

        timestamps()
    end

    def create_or_update_changeset(struct, params) do
        struct
        |> cast(params, [:name, :members, :admins])
        |> validate_required([:name, :admins])
        |> set_unique()
    end

    defp set_unique(changeset) do
        case changeset do
            %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
                hashed_name = :crypto.hash(:sha256, name) |> Base.encode16
                unique = hashed_name <> Integer.to_string(:os.system_time(:micro_seconds))
                put_change(changeset, :unique, unique)
            _ ->
                changeset
        end
    end
end