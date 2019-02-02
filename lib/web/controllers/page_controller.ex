defmodule TlcApp.Web.PageController do
  use TlcApp.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
