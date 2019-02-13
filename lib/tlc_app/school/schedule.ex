defmodule TlcApp.School.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start_date, :end_date, :stream, :course_id, :diet]}

  @fields [:stream, :start_date, :end_date, :course_id, :diet]

  schema "schedules" do
    field :start_date, :integer
    field :end_date, :integer
    field :stream, :integer
    field :diet, :string
    belongs_to :course, TlcApp.School.Course

    timestamps()
  end

  def changeset(%__MODULE__{} = timetable, attrs) do
    timetable
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
