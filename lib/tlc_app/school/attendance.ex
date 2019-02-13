defmodule TlcApp.School.Attendance do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :user_id, :schedule_id, :inserted_at]}

  @fields [:user_id, :schedule_id]

  schema "attendances" do
    belongs_to :user, TlcApp.Accounts.User
    belongs_to :schedule, TlcApp.School.Schedule

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = attendance, attrs) do
    attendance
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
