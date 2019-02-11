defmodule TlcApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :phone, :string
      add :password_hash, :string
      add :role, :string
      add :active, :boolean, default: true

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:phone])
  end
end
