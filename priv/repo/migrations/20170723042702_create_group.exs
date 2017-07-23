defmodule Portal.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :members, :string
      add :admins, :string
      add :creator_id, references(:users, on_delete: :nothing)

      timestamps()
    end

  end
end
