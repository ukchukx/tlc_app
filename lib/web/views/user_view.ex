defmodule TlcApp.Web.UserView do
  use TlcApp.Web, :view

  alias TlcApp.Accounts.User
  alias TlcApp.School

  def display_role(%User{role: "staff"}), do: "Staff"
  def display_role(%User{role: "student"}), do: "Student"
  def user_roles, do: ["Student": User.student_role(), "Staff": User.staff_role()]

  def courses, do: School.course_names_and_ids()
  def streams, do: School.list_streams()
  def course_regs(user), do: School.list_course_regs(user.id) |> School.load_course
end
