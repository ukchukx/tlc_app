defmodule TlcApp.Web.UserView do
  use TlcApp.Web, :view

  alias TlcApp.School

  def courses, do: School.course_names_and_ids()
  def streams, do: School.list_streams()
  def course_regs(user), do: School.list_course_regs(user.id) |> School.load_course
end
