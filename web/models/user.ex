defmodule Portal.User do
    use Portal.Web, :model

    schema "users" do
        field :name, :string
        field :username, :string
        field :password, :string, virtual: true
        field :password_hash, :string
        field :credits, :integer, default: 0
        
        timestamps()
    end

    def new_changeset(struct, params \\ :invalid) do
        struct
        |> cast(params, [:name, :username, :password, :credits])
        |> validate_required([:name, :username, :password, :credits])
        |> validate_length(:username, min: 5, max: 255)
        |> validate_length(:password, min: 6, max: 255)
        |> unique_constraint(:username)
    end

    def create_changeset(struct, params) do
        struct
        |> new_changeset(params)
        |> set_password_hash()
    end

    def update_changeset(struct, params) do
        struct
        |> cast(params, [:name, :username, :password, :credits])
        |> validate_required([:name, :username, :password, :credits])
        |> validate_length(:username, min: 5, max: 255)
        |> validate_length(:password, min: 6, max: 255)
        |> unique_constraint(:username)
        |> set_password_hash()
    end

    defp set_password_hash(changeset) do
        case changeset do
            %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
                passwd = :crypto.hash(:sha256, pass) |> Base.encode16
                put_change(changeset, :password_hash, passwd)
            _ ->
                changeset
        end
    end
end
