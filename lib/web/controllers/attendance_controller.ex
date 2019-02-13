defmodule TlcApp.Web.AttendanceController do
  use TlcApp.Web, :controller
  alias TlcApp.School

  def index(%{assigns: %{current_user: %{role: "staff"} = user}} = conn, _) do
    render conn, "index.html",
      schedules: School.get_past_schedules_for_current_diet(),
      courses: School.list_courses(),
      user: user,
      title: "Attendance"
  end

  def download(%{assigns: %{current_user: %{role: "staff"}}} = conn, %{"id" => id}) do
    attendances = School.list_attendances_for_schedule(id)

    data =
      attendances
      |> Enum.reduce([[["Name", bold: true], ["Email", bold: true], ["Phone", bold: true]]], fn a, rows ->
        rows ++ [["#{a.user.first_name} #{a.user.last_name}", a.user.email, a.user.phone]]
      end)

      sheet = %Elixlsx.Sheet{name: "Attendance", rows: data}
      workbook = %Elixlsx.Workbook{sheets: [sheet]}
      {:ok, {_filename, binary}} = Elixlsx.write_to_memory(workbook, "attendance.xlsx")

    conn
    |> put_resp_content_type("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    |> put_resp_header("content-disposition", "attachment; filename=attendance.xlsx")
    |> send_resp(200, binary)
  end
end
