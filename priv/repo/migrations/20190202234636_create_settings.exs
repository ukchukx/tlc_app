defmodule TlcApp.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :name, :string
      add :value, :string

      timestamps()
    end

    create unique_index(:settings, [:name])
  end
end
