defmodule TlcApp.Web.CourseController do
  use TlcApp.Web, :controller

  alias TlcApp.School
  # alias TlcApp.School.Course

  def index(%{assigns: %{current_user: %{} = user}} = conn, _params) do
    render conn, "index.html", courses: School.list_courses(), user: user
  end

  def create(conn, %{"course" => course_params}) do
    case School.create_course(course_params) do
      {:ok, course} ->
        json(conn, %{data: course, success: true})

      {:error, %Ecto.Changeset{} = changeset} ->
        json(conn, %{data: changeset, success: false})
    end
  end

  def show(%{assigns: %{current_user: %{} = user}} = conn, %{"id" => id}) do
    case School.get_course(id) do
      {:ok, course} ->
        render conn, "show.html", course: course, user: user

      _ ->
        redirect(conn, to: Routes.course_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    case School.get_course(id) do
      {:ok, course} ->
        case School.update_course(course, course_params) do
          {:ok, course} ->
            json(conn, %{data: course, success: true})

          {:error, %Ecto.Changeset{} = changeset} ->
            json(conn, %{data: changeset, success: false})
        end

      _ ->
        json(conn, %{success: false})
    end
  end

  def delete(conn, %{"id" => id}) do
    case School.get_course(id) do
      {:ok, course} ->
        {:ok, _} = School.delete_course(course)
        json(conn, %{success: true})
      _ ->
        json(conn, %{success: false})
    end
  end

  def delete_schedule(conn, %{"id" => id}) do
    case School.get_schedule(id) do
      %{} = s ->
        {:ok, _} = School.delete_schedule(s)
        json(conn, %{success: true})
      _ ->
        json(conn, %{success: false})
    end
  end

  def create_schedules(conn, %{"id" => id, "schedules" => schedule_params}) do
    schedule_params = Enum.map(schedule_params, fn p -> Map.put(p, "course_id", id) end)

    case School.create_multiple_schedules(schedule_params) do
      :ok  ->
        json(conn, %{data: School.list_schedules(%{course: id}), success: true})

      {:error, changesets} ->
        json(conn, %{data: changesets, success: false})
    end
  end
end
