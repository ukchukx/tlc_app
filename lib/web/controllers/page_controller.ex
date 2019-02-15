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
    course_regs = School.list_course_regs_for_current_diet(id)
    course_ids = Enum.map(course_regs, &(&1.course_id))

    today = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    
    courses = 
      School.list_courses
      |> Enum.filter(&(&1.id in course_ids)) # Get only courses the student is registered for
      |> School.load_schedules
      |> Enum.map(fn course = %{id: id, schedules: schedules} ->  
        %{stream: stream } = Enum.find(course_regs, &(&1.course_id == id))
        schedules = 
          schedules
          |> Enum.filter(&(&1.stream == stream)) # Take only schedules for the student's stream
          |> Enum.filter(&(&1.start_date >= today)) # Take only schedules that are not in the past
          |> Enum.sort(&(&1.start_date <= &2.start_date)) # Latest first

        Map.put(course, :schedules, schedules)
      end)

    render conn, "index.html",
      user: user,
      course_regs: School.list_course_regs_for_current_diet(id),
      courses: courses,
      schedules: School.get_ongoing_schedules(id),
      title: "Home"
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))

end
