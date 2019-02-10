defmodule TlcApp.Web.PageController do
  use TlcApp.Web, :controller

  def bo_index(%{assigns: %{current_user: %{} = user}} = conn, _params) do
    render conn, "bo_index.html", user: user
  end

  def index(%{assigns: %{current_user: %{}}} = conn, _params) do
    render(conn, "index.html")
  end

  def index(conn, params), do:  catch_all(conn, params)

  def catch_all(conn, _params) do
    redirect(conn, to: TlcApp.Web.SessionController.get_home_path(conn))
  end
end
