defmodule Portal.Repo.Migrations.CreateInvitation do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :from_id, :id
      add :to_id, references(:users, on_delete: :nothing)
      add :invit_type, :string
      add :invit_msg, :string
      add :status, :string
      add :opened, :boolean

      timestamps()
    end
  end
end
