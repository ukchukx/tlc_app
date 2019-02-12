defmodule TlcApp.Repo.Migrations.CreateCourseRegs do
  use Ecto.Migration

  def change do
    create table(:course_regs) do
      add :diet, :string
      add :stream, :smallint
      add :user_id, references(:users, on_delete: :nothing)
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end

    create index(:course_regs, [:diet])
  end
end
