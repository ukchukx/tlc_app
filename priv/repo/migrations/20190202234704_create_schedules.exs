defmodule TlcApp.Repo.Migrations.CreateTimeTables do
  use Ecto.Migration

  def change do
    create table(:schedules) do
      add :start_date, :bigint
      add :end_date, :bigint
      add :stream, :smallint
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end
  end
end
