defmodule TlcApp.School.CourseReg do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:diet, :user_id, :course_id, :stream_id]

  schema "course_regs" do
    field :diet, :string

    belongs_to :user, TlcApp.Accounts.User
    belongs_to :course, TlcApp.School.Course
    belongs_to :stream, TlcApp.School.Stream

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = course_reg, attrs) do
    course_reg
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
