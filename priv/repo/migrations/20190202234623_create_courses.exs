defmodule TlcApp.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :code, :string

      timestamps()
    end

    create unique_index(:courses, [:name])
    create unique_index(:courses, [:code])
  end
end
