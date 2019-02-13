defmodule TlcApp.Web.UserController do
  use TlcApp.Web, :controller

  alias TlcApp.{Accounts, School}

  def index(%{assigns: %{current_user: %{id: id, role: "staff"} = user}} = conn, _) do
    users =
      Accounts.list_users()
      |> Enum.filter(&(id != &1.id))

    render conn, "index.html",
      users: users,
      user: user,
      title: "Users"
  end

  def create(%{assigns: %{current_user: %{role: "staff"}}} = conn, %{"user" => %{"role" => role, "phone" => phone } = user_params}) do
    # Assign phone number as the default password, if there's no password
    user_params =
      case Map.has_key?(user_params, "password") do
        true -> user_params
        false -> Map.put(user_params, "password", phone)
      end

    case role do
      "student" ->
        case Accounts.create_student(user_params) do
          {:ok, user} ->
            json(conn, %{success: true, data: user})
          {:error, %Ecto.Changeset{} = changeset} ->
            json(conn, %{success: false, data: changeset})
        end

      "staff" ->
        case Accounts.create_staff(user_params) do
          {:ok, user} ->
            json(conn, %{success: true, data: user})
          {:error, %Ecto.Changeset{} = changeset} ->
            json(conn, %{success: false, data: changeset})
        end
    end
  end

  def show(%{assigns: %{current_user: %{role: "staff"} = auth_user}} = conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      %{} = user ->
        render conn, "show.html",
          user: user,
          auth_user: auth_user,
          courses: School.list_courses(),
          course_regs: School.list_course_regs_for_current_diet(id)
      _ ->
        redirect(conn, to: Routes.user_path(conn, :index))
    end
  end

  def update(%{assigns: %{current_user: %{id: id, role: "student"} = user}} = conn, %{"id" => id, "user" => user_params}) do
    data = do_update(user, user_params)
    json(conn, data)
  end

  def update(%{assigns: %{current_user: %{role: "staff"}}} = conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    data = do_update(user, user_params)
    json(conn, data)
  end

  def add_course_reg(%{assigns: %{current_user: %{role: "staff"}}} = conn, %{"course_reg" => %{"user_id" => uid } = params}) do
    Accounts.get_user!(uid)

    case School.create_course_reg(params) do
      {:ok, creg} -> json(conn, %{success: true, data: creg})

      {:error, %Ecto.Changeset{} = changeset} -> json(conn, %{success: false, data: changeset})
    end
  end


  def delete_course_reg(%{assigns: %{current_user: %{role: "staff"}}} = conn, %{"id" => id}) do
    {:ok, _} = id |> School.get_course_reg! |> School.delete_course_reg
    json(conn, %{success: true})
  end

  def delete(%{assigns: %{current_user: %{role: "staff"}}} = conn, %{"id" => id}) do
    {:ok, _} = id |> Accounts.get_user! |> Accounts.delete_user
    json(conn, %{success: true})
  end

  def sign_attendance(conn, %{"attendance" => %{"user_id" => uid, "schedule_id" => sid} = params}) do
    case School.have_signed_today(uid, sid) do
      true ->
        json(conn, %{
          success: true,
          data: School.get_ongoing_schedules(uid),
          message: "Attendance already marked"})

      false ->
        {:ok, _} = School.create_attendance(params)
        json(conn, %{
          success: true,
          data: School.get_ongoing_schedules(uid),
          message: "Attendance marked"})
    end
  end


  defp do_update(user, params) do
    case Accounts.update_user(user, params) do
      {:ok, user} -> %{success: true, data: user}

      {:error, %Ecto.Changeset{} = changeset} -> %{success: false, data: changeset}
    end
  end
end
