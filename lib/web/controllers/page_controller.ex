defmodule TlcApp.Web.PageController do
  use TlcApp.Web, :controller

  alias TlcApp.{Accounts, School}

  def index(%{assigns: %{current_user: %{role: "staff"} = user}} = conn, _) do
    course_count = School.list_courses() |> length
    active_student_count = Accounts.list_active_students() |> length
    staff_count = Accounts.list_staff() |> length

    render conn, "bo_index.html",
      user: user,
      course_count: course_count,
      active_student_count: active_student_count,
      staff_count: staff_count,
      title: "Home"
  end

  def index(%{assigns: %{current_user: %{role: "student", id: id} = user}} = conn, _) do
    render conn, "index.html",
      user: user,
      course_regs: School.list_course_regs_for_current_diet(id),
      courses: School.list_courses(),
      schedules: School.get_ongoing_schedules(id),
      title: "Home"
  end

  def index(conn, params), do:  catch_all(conn, params)

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))

end
