defmodule TlcApp.Web.PageController do
  use TlcApp.Web, :controller

  alias TlcApp.{Accounts, School}

  def bo_index(%{assigns: %{current_user: %{} = user}} = conn, _params) do
    course_count = School.list_courses() |> length
    active_student_count = Accounts.list_active_students() |> length
    staff_count = Accounts.list_staff() |> length

    render conn, "bo_index.html",
      user: user,
      course_count: course_count,
      active_student_count: active_student_count,
      staff_count: staff_count
  end

  def index(%{assigns: %{current_user: %{role: "student"}}} = conn, _params) do
    render(conn, "index.html")
  end

  def index(conn, params), do:  catch_all(conn, params)

  def catch_all(conn, _params) do
    redirect(conn, to: TlcApp.Web.SessionController.get_home_path(conn))
  end
end
