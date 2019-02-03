defmodule TlcApp.School.Stream do
  use Ecto.Schema
  import Ecto.Changeset


  schema "streams" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = stream, attrs) do
    stream
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
