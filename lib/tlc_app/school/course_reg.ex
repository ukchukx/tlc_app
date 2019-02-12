defmodule TlcApp.School.CourseReg do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :diet, :user_id, :course_id, :stream]}

  @fields [:diet, :user_id, :course_id, :stream]

  schema "course_regs" do
    field :diet, :string
    field :stream, :integer

    belongs_to :user, TlcApp.Accounts.User
    belongs_to :course, TlcApp.School.Course

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = course_reg, attrs) do
    course_reg
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
