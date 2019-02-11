defmodule TlcApp.Web.SessionController do
  use TlcApp.Web, :controller

  alias TlcApp.Accounts
  alias TlcApp.Accounts.User

  def signin(%Plug.Conn{assigns: %{current_user: %Accounts.User{}}}=conn, _) do
    redirect(conn, to: get_home_path(conn))
  end

  def signin(conn, _) do
    render conn, "new.html", path: Routes.session_path(conn, :create_session)
  end

  def create_session(conn, %{"email" => email, "password" => pass}) do
    case Accounts.signin_with_email_and_password(conn, email, pass) do
      {:ok, conn} ->
        home_path = get_home_path(conn)
        conn
        |> redirect(to: home_path)
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password")
        |> redirect(to: Routes.session_path(conn, :signin))
    end
  end

  def delete_session(conn, _) do
    conn
    |> clear_session
    |> redirect(to: Routes.session_path(conn, :signin))
  end

  def get_home_path(conn) do
    case conn.assigns.current_user do
      nil -> Routes.session_path(conn, :signin)
      %User{role: "student"} -> Routes.page_path(conn, :index)
      %User{role: "staff"} -> Routes.page_path(conn, :bo_index)
    end
  end
end

