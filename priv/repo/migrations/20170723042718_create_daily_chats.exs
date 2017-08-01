defmodule Portal.Repo.Migrations.CreateDailyChats do
  use Ecto.Migration

  def change do
    create table(:daily_chats) do
      add :read, :boolean
      add :messages, :longtext
      add :type, :string
      add :counter_id, :bigint
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
