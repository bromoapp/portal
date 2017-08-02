defmodule Portal.Repo.Migrations.CreateGroup do
  use Ecto.Migration
  
  def change do
    create table(:groups) do
      add :unique, :text
      add :name, :string
      add :members, :longtext
      add :admins, :string

      timestamps()
    end
  end

end
