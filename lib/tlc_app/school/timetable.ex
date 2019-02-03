defmodule TlcApp.School.Timetable do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:day, :start_time, :end_time, :course_id, :stream_id]

  schema "time_tables" do
    field :day, :string
    field :end_time, :string
    field :start_time, :string
    belongs_to :course, TlcApp.School.Course
    belongs_to :stream, TlcApp.School.Stream

    timestamps()
  end

  def changeset(%__MODULE__{} = timetable, attrs) do
    timetable
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> capitalize_day
  end

  def capitalize_day(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{day: day}} ->
        put_change(changeset, :day, String.capitalize(day))
      _ ->
        changeset
    end
  end
end
