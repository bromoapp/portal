defmodule Portal.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :owner_id, :bigint
      add :owner, :string
      add :tag, :string
      add :name, :string
      add :ext, :string
      add :size, :integer
      add :file, :binary

      timestamps()
    end
  end
end
