defmodule Portal.Repo.Migrations.CreateDailyChat do
  use Ecto.Migration

  def change do
    create table(:daily_chats) do
      add :messages, :string
      add :user_a_id, references(:users, on_delete: :nothing)
      add :user_b_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
