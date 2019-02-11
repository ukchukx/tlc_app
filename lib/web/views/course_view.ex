defmodule TlcApp.Web.CourseView do
  use TlcApp.Web, :view

  def streams do
    TlcApp.School.list_streams()
  end
end
