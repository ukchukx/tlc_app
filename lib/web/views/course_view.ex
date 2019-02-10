defmodule TlcApp.Web.CourseView do
  use TlcApp.Web, :view

  def days  do
    ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  end
end
