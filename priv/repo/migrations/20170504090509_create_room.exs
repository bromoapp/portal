defmodule Portal.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :mode, :string

      timestamps()
    end

  end
end
