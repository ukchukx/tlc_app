defmodule TlcApp.School.Setting do
  use Ecto.Schema
  import Ecto.Changeset


  schema "settings" do
    field :name, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = setting, attrs) do
    setting
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end

  def key(:current_diet), do: "curr_diet"
end
