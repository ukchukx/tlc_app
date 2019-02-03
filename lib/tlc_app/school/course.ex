defmodule TlcApp.School.Course do
  use Ecto.Schema
  import Ecto.Changeset


  schema "courses" do
    field :name, :string
    has_many :time_tables, TlcApp.School.Timetable

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = course, attrs) do
    course
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> up_name_case
    |> unique_constraint(:name)
  end

  defp up_name_case(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
        put_change(changeset, :name, String.upcase(name))
      _ ->
        changeset
    end
  end
end
