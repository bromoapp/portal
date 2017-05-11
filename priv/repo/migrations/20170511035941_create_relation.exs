defmodule Portal.Repo.Migrations.CreateRelation do
  use Ecto.Migration

  def change do
    create table(:relations) do
      add :tags, :string
      add :user_a, references(:users, on_delete: :nothing)
      add :user_b, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
