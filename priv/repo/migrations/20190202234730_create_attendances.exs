defmodule TlcApp.Repo.Migrations.CreateAttendances do
  use Ecto.Migration

  def change do
    create table(:attendances) do
      add :user_id, references(:users, on_delete: :nothing)
      add :schedule_id, references(:schedules, on_delete: :nothing)

      timestamps()
    end
  end
end
