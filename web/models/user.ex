defmodule Portal.User do
  use Portal.Web, :model

  schema "users" do
      field :name, :string
      field :username, :string
      field :password, :string, virtual: true
      field :password_hash, :string

      timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ :invalid) do
      struct
      |> cast(params, [:name, :username, :password])
      |> validate_required([:name, :username, :password])
      |> validate_length(:username, min: 5, max: 20)
      |> validate_length(:password, min: 6, max: 15)
      |> unique_constraint(:username)
  end

  def register_changeset(struct, params) do
      struct
      |> changeset(params)
      |> set_password_hash()
  end

  def update_changeset(struct, params) do
      struct
      |> cast(params, [:name, :username, :password])
      |> validate_length(:username, min: 5, max: 20)
      |> validate_length(:password, min: 6, max: 15)
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
