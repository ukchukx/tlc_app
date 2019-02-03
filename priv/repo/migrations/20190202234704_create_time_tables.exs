defmodule TlcApp.Repo.Migrations.CreateTimeTables do
  use Ecto.Migration

  def change do
    create table(:time_tables) do
      add :day, :string
      add :start_time, :string
      add :end_time, :string
      add :course_id, references(:courses, on_delete: :nothing)
      add :stream_id, references(:streams, on_delete: :nothing)

      timestamps()
    end
  end
end
