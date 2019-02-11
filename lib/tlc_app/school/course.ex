defmodule TlcApp.School.Course do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :code, :schedules]}

  schema "courses" do
    field :name, :string
    field :code, :string
    has_many :schedules, TlcApp.School.Schedule

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = course, attrs) do
    course
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
    |> upcase_name
    |> upcase_code
    |> unique_constraint(:code)
  end

  defp upcase_name(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
        put_change(changeset, :name, String.upcase(name))
      _ ->
        changeset
    end
  end

  defp upcase_code(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{code: code}} ->
        put_change(changeset, :code, String.upcase(code))
      _ ->
        changeset
    end
  end
end
