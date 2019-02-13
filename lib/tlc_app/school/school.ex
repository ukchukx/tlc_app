defmodule TlcApp.School do
  @moduledoc """
  The School context.
  """

  import Ecto.Query, warn: false
  alias TlcApp.Repo

  alias TlcApp.School.Course
  alias TlcApp.School.Attendance
  alias TlcApp.School.CourseReg
  alias TlcApp.School.Schedule

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    Course |> preload(:schedules) |> Repo.all
  end

  def course_names_and_ids do
    Repo.all(from c in Course, select: {c.name, c.code, c.id})
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.

  ## Examples

      iex> get_course!(123)
      %Course{}

      iex> get_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course!(id), do: Course |> Repo.get!(id) |> Repo.preload(:schedules)

  def get_course(id) do
    Course
    |> preload(:schedules)
    |> Repo.get(id)
    |> case do
      %Course{} = c -> {:ok, c}
      _ -> {:error, nil}
    end
  end

  @doc """
  Creates a course.

  ## Examples

      iex> create_course(%{field: value})
      {:ok, %Course{}}

      iex> create_course(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, course} -> {:ok, Repo.preload(course, :schedules)}
      other -> other
    end
  end

  @doc """
  Updates a course.

  ## Examples

      iex> update_course(course, %{field: new_value})
      {:ok, %Course{}}

      iex> update_course(course, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, course} -> {:ok, Repo.preload(course, :schedules)}
      other -> other
    end
  end

  @doc """
  Deletes a Course.

  ## Examples

      iex> delete_course(course)
      {:ok, %Course{}}

      iex> delete_course(course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course changes.

  ## Examples

      iex> change_course(course)
      %Ecto.Changeset{source: %Course{}}

  """
  def change_course(%Course{} = course) do
    Course.changeset(course, %{})
  end


  def list_streams do
    [%{id: 1, name: "Stream 1"}, %{id: 2, name: "Stream 2"}]
  end

  @doc """
  Returns the list of attendances.

  ## Examples

      iex> list_attendances()
      [%Attendance{}, ...]

  """
  def list_attendances do
    Repo.all(Attendance)
  end

  @doc """
  Gets a single attendance.

  Raises `Ecto.NoResultsError` if the Attendance does not exist.

  ## Examples

      iex> get_attendance!(123)
      %Attendance{}

      iex> get_attendance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attendance!(id), do: Repo.get!(Attendance, id)

  def have_signed_today(user_id, schedule_id) do
    query = from a in Attendance, where: a.user_id == ^user_id and a.schedule_id == ^schedule_id
    Repo.aggregate(query, :count, :schedule_id) > 0
  end

  @doc """
  Creates a attendance.

  ## Examples

      iex> create_attendance(%{field: value})
      {:ok, %Attendance{}}

      iex> create_attendance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attendance(attrs) do
    %Attendance{}
    |> Attendance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attendance.

  ## Examples

      iex> update_attendance(attendance, %{field: new_value})
      {:ok, %Attendance{}}

      iex> update_attendance(attendance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attendance(%Attendance{} = attendance, attrs) do
    attendance
    |> Attendance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attendance.

  ## Examples

      iex> delete_attendance(attendance)
      {:ok, %Attendance{}}

      iex> delete_attendance(attendance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attendance(%Attendance{} = attendance) do
    Repo.delete(attendance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attendance changes.

  ## Examples

      iex> change_attendance(attendance)
      %Ecto.Changeset{source: %Attendance{}}

  """
  def change_attendance(%Attendance{} = attendance) do
    Attendance.changeset(attendance, %{})
  end

  @doc """
  Returns the list of course_regs.

  ## Examples

      iex> list_course_regs()
      [%CourseReg{}, ...]

  """
  def list_course_regs do
    Repo.all(CourseReg)
  end

  def list_course_regs(user_id) do
    Repo.all(from c in CourseReg, where: c.user_id == ^user_id)
  end

  def current_diet do
    today = DateTime.utc_now()
    month =
      case today.month > 5 do
        true -> "November"
        false -> "May"
      end

    "#{month}, #{today.year}"
  end

  def list_course_regs_for_current_diet(user_id) do
    Repo.all(from c in CourseReg, where: c.user_id == ^user_id and c.diet == ^current_diet())
  end

  def load_course(resources), do: resources |> Enum.map(&Repo.preload(&1, :course))

  @doc """
  Gets a single course_reg.

  Raises `Ecto.NoResultsError` if the Course reg does not exist.

  ## Examples

      iex> get_course_reg!(123)
      %CourseReg{}

      iex> get_course_reg!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course_reg!(id), do: Repo.get!(CourseReg, id)

  def get_ongoing_schedules(student_id) do
    now = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    course_ids =
      student_id
      |> list_course_regs_for_current_diet
      |> Enum.map(&(&1.course_id))

    query = from s in Schedule, where: s.course_id in ^course_ids and s.start_date <= ^now and s.end_date >= ^now

    query
    |> Repo.all
    |> Enum.filter(fn %{id: id} -> ! have_signed_today(student_id, id) end)
  end

  @doc """
  Creates a course_reg.

  ## Examples

      iex> create_course_reg(%{field: value})
      {:ok, %CourseReg{}}

      iex> create_course_reg(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course_reg(%{"course_id" => cid, "stream" => s, "user_id" => uid, "diet" => d}=attrs) do
    query = from c in CourseReg, where: c.diet == ^d and c.course_id == ^cid and c.stream == ^s and c.user_id == ^uid

    query
    |> Repo.one
    |> case do
      %CourseReg{} = cr ->
        {:ok, cr}

      _ ->
        %CourseReg{}
        |> CourseReg.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a course_reg.

  ## Examples

      iex> update_course_reg(course_reg, %{field: new_value})
      {:ok, %CourseReg{}}

      iex> update_course_reg(course_reg, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course_reg(%CourseReg{} = course_reg, attrs) do
    course_reg
    |> CourseReg.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CourseReg.

  ## Examples

      iex> delete_course_reg(course_reg)
      {:ok, %CourseReg{}}

      iex> delete_course_reg(course_reg)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course_reg(%CourseReg{} = course_reg) do
    Repo.delete(course_reg)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course_reg changes.

  ## Examples

      iex> change_course_reg(course_reg)
      %Ecto.Changeset{source: %CourseReg{}}

  """
  def change_course_reg(%CourseReg{} = course_reg) do
    CourseReg.changeset(course_reg, %{})
  end

  @doc """
  Returns the list of time_tables.

  ## Examples

      iex> list_time_tables()
      [%Schedule{}, ...]

  """
  def list_schedules do
    Repo.all(Schedule)
  end

  def list_schedules(%{course: cid, stream: s}) do
    Repo.all(from t in Schedule, where: t.course_id == ^cid and t.stream == ^s)
  end

  def list_schedules(%{course: cid}) do
    Repo.all(from t in Schedule, where: t.course_id == ^cid)
  end

  @doc """
  Gets a single schedule.

  Raises `Ecto.NoResultsError` if the Schedule does not exist.

  """
  def get_schedule!(id), do: Repo.get!(Schedule, id)

  def get_schedule(id), do: Repo.get(Schedule, id)

  @doc """
  Creates a schedule.

  ## Examples

      iex> create_schedule(%{field: value})
      {:ok, %Schedule{}}

      iex> create_schedule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schedule(attrs \\ %{}) do
    %Schedule{}
    |> Schedule.changeset(attrs)
    |> Repo.insert()
  end

  def create_multiple_schedules(param_list) do
    timestamp = fn ->
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)
    end

    param_list
    |> Stream.filter(fn %{"start_date" => start, "stream" => stream} ->
      q = from s in Schedule, where: s.start_date == ^start and s.stream == ^stream
      Repo.aggregate(q, :count, :id) == 0
    end)
    |> Stream.map(&(Schedule.changeset(%Schedule{}, &1)))
    |> Enum.split_with(&(&1.valid?))
    |> case do
      {valid_changesets, []} ->
        raw_data =
          valid_changesets
          |> Stream.map(&(Ecto.Changeset.apply_changes(&1))) # turns item changesets into a list of %Schedule{}
          |> Enum.map(fn item -> # turns %Schedule{} into a map with only non-nil item values (no association or __meta__ structs)
            item
            |> Map.from_struct
            |> Stream.reject(fn # or something similar
              {_key, nil} -> true

              {_key, %_struct{}} ->
                # rejects __meta__: #Ecto.Schema.Metadata<:built, "schedules">
                # and association: #Ecto.Association.NotLoaded<association :association is not loaded>
                true

              _ -> false
            end)
            |> Enum.into(%{inserted_at: timestamp.(), updated_at: timestamp.()}) # not really necessary since `insert_all` also accepts a list of lists.
          end)
          # maybe filter for empty maps/lists

        Repo.insert_all(Schedule, raw_data)
        :ok
      {_, invalid_changesets} -> {:error, invalid_changesets}
    end
  end

  @doc """
  Updates a schedule.

  ## Examples

      iex> update_schedule(schedule, %{field: new_value})
      {:ok, %Schedule{}}

      iex> update_schedule(schedule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_schedule(%Schedule{} = schedule, attrs) do
    schedule
    |> Schedule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Schedule.

  ## Examples

      iex> delete_schedule(schedule)
      {:ok, %Schedule{}}

      iex> delete_schedule(schedule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_schedule(%Schedule{} = schedule) do
    Repo.delete(schedule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schedule changes.

  ## Examples

      iex> change_schedule(schedule)
      %Ecto.Changeset{source: %Schedule{}}

  """
  def change_schedule(%Schedule{} = schedule, attrs \\ %{}) do
    Schedule.changeset(schedule, attrs)
  end
end
