defmodule TlcApp.Repo.Migrations.CreateAttendances do
  use Ecto.Migration

  def change do
    create table(:attendances) do
      add :user_id, references(:users, on_delete: :nothing)
      add :time_table_id, references(:time_tables, on_delete: :nothing)

      timestamps()
    end
  end
end
