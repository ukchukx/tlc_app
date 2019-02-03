defmodule TlcApp.School.Attendance do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:user_id, :time_table_id]

  schema "attendances" do
    belongs_to :user, TlcApp.Accounts.User
    belongs_to :time_table, TlcApp.School.Timetable

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = attendance, attrs) do
    attendance
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
