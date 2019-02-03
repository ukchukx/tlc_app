defmodule TlcApp.Repo.Migrations.CreateCourseRegs do
  use Ecto.Migration

  def change do
    create table(:course_regs) do
      add :diet, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :course_id, references(:courses, on_delete: :nothing)
      add :stream_id, references(:streams, on_delete: :nothing)

      timestamps()
    end
  end
end
