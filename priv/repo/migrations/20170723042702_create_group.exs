defmodule Portal.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :members, :string
      add :admins, :string

      timestamps()
    end

  end
end
