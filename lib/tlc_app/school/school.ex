defmodule TlcApp.School do
  @moduledoc """
  The School context.
  """

  import Ecto.Query, warn: false
  alias TlcApp.Repo

  alias TlcApp.School.Course
  alias TlcApp.School.Stream
  alias TlcApp.School.Setting
  alias TlcApp.School.Attendance
  alias TlcApp.School.CourseReg
  alias TlcApp.School.Timetable

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    Repo.all(Course)
  end

  def course_names_and_ids do
    Repo.all(from c in Course, select: {c.name, c.id})
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
  def get_course!(id), do: Repo.get!(Course, id)

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

  @doc """
  Returns the list of streams.

  ## Examples

      iex> list_streams()
      [%Stream{}, ...]

  """
  def list_streams do
    Repo.all(Stream)
  end

  def stream_names_and_ids do
    Repo.all(from s in Stream, select: {s.name, s.id})
  end

  @doc """
  Gets a single stream.

  Raises `Ecto.NoResultsError` if the Stream does not exist.

  ## Examples

      iex> get_stream!(123)
      %Stream{}

      iex> get_stream!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stream!(id), do: Repo.get!(Stream, id)

  @doc """
  Creates a stream.

  ## Examples

      iex> create_stream(%{field: value})
      {:ok, %Stream{}}

      iex> create_stream(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stream(attrs \\ %{}) do
    %Stream{}
    |> Stream.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stream.

  ## Examples

      iex> update_stream(stream, %{field: new_value})
      {:ok, %Stream{}}

      iex> update_stream(stream, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stream(%Stream{} = stream, attrs) do
    stream
    |> Stream.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Stream.

  ## Examples

      iex> delete_stream(stream)
      {:ok, %Stream{}}

      iex> delete_stream(stream)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stream(%Stream{} = stream) do
    Repo.delete(stream)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stream changes.

  ## Examples

      iex> change_stream(stream)
      %Ecto.Changeset{source: %Stream{}}

  """
  def change_stream(%Stream{} = stream) do
    Stream.changeset(stream, %{})
  end


  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)
  def get_setting(name: name), do: Repo.get_by(Setting, name: name)

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Setting.

  ## Examples

      iex> delete_setting(setting)
      {:ok, %Setting{}}

      iex> delete_setting(setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

      iex> change_setting(setting)
      %Ecto.Changeset{source: %Setting{}}

  """
  def change_setting(%Setting{} = setting) do
    Setting.changeset(setting, %{})
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

  def have_signed_today(user_id, period_id) do
    {{y, m, d}, _} = :calendar.local_time()

    Repo.all(from a in Attendance, where: a.user_id == ^user_id and a.time_table_id == ^period_id)
    |> Enum.map(&NaiveDateTime.to_erl(&1.inserted_at))
    |> Enum.filter(fn {{y1, m1, d1}, _} -> y1 == y and m1 == m and d1 == d  end)
    |> Enum.count
    |> Kernel.>(0)
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

  def list_course_regs_for_current_diet(user_id) do
    %Setting{value: curr_diet} = get_setting(name: Setting.key(:current_diet))
    Repo.all(from c in CourseReg, where: c.user_id == ^user_id and c.diet == ^curr_diet)
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

  @days %{1 => "Monday", 2 => "Tuesday", 3 => "Wednesday",
    4 => "Thursday", 5 => "Friday", 6 => "Saturday", 7 => "Sunday"}

  def time_between(start_time, end_time) do
    {date, {h, m, _}} = :calendar.local_time()
    now_ts = to_ts({date, {h, m, 0}})
    [sh, sm] = start_time |> String.split(":", trim: true) |> Enum.map(&String.to_integer(&1))
    start_ts = to_ts({date, {sh, sm, 0}})
    [eh, em] = end_time |> String.split(":", trim: true) |> Enum.map(&String.to_integer(&1))
    end_ts = to_ts({date, {eh, em, 0}})

    now_ts >= start_ts and now_ts <= end_ts
  end

  defp to_ts({{_,_,_},{_,_,_}}=datetime_tup), do:  :calendar.datetime_to_gregorian_seconds(datetime_tup) - 62167219200

  def get_ongoing_courses(student_id) do
    {{y, m, d}, {h, min, _}} = :calendar.local_time()
    today = Map.get(@days, :calendar.day_of_the_week(y, m, d))
    regs = list_course_regs_for_current_diet(student_id)

    list_time_tables
    |> Enum.filter(&(&1.day == today))
    |> Enum.filter(fn entry -> Enum.any?(regs, &(entry.course_id == &1.id)) end)
    |> Enum.filter(fn entry -> Enum.any?(regs, &(entry.stream_id == &1.stream_id)) end)
    |> Enum.filter(&(time_between(&1.start_time, &1.end_time)))
    |> Enum.map(&Repo.preload(&1, :course))
  end

  @doc """
  Creates a course_reg.

  ## Examples

      iex> create_course_reg(%{field: value})
      {:ok, %CourseReg{}}

      iex> create_course_reg(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course_reg(%{"course_id" => cid, "stream_id" => sid, "user_id" => uid}=attrs) do
    curr_diet = Repo.get_by!(Setting, name: "curr_diet")
    attrs = Map.put(attrs, "diet", curr_diet.value)

    cr = Repo.one(from c in CourseReg, where: c.diet == ^curr_diet.value and c.course_id == ^cid and
                  c.stream_id == ^sid and c.user_id == ^uid)

    case cr do
      %CourseReg{} ->
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
      [%Timetable{}, ...]

  """
  def list_time_tables do
    Repo.all(Timetable)
  end

  def list_time_tables(%{course: cid, stream: sid}) do
    Repo.all(from t in Timetable, where: t.course_id == ^cid and t.stream_id == ^sid)
  end

  def list_time_tables(%{course: cid}) do
    Repo.all(from t in Timetable, where: t.course_id == ^cid)
  end

  def load_stream(resources), do: resources |> Enum.map(&Repo.preload(&1, :stream))

  @doc """
  Gets a single timetable.

  Raises `Ecto.NoResultsError` if the Timetable does not exist.

  ## Examples

      iex> get_timetable!(123)
      %Timetable{}

      iex> get_timetable!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timetable!(id), do: Repo.get!(Timetable, id)

  @doc """
  Creates a timetable.

  ## Examples

      iex> create_timetable(%{field: value})
      {:ok, %Timetable{}}

      iex> create_timetable(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timetable(attrs \\ %{}) do
    %Timetable{}
    |> Timetable.changeset(attrs)
    |> Repo.insert()
  end

  def create_timeperiod(attrs) do
    %Timetable{}
    |> Timetable.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timetable.

  ## Examples

      iex> update_timetable(timetable, %{field: new_value})
      {:ok, %Timetable{}}

      iex> update_timetable(timetable, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timetable(%Timetable{} = timetable, attrs) do
    timetable
    |> Timetable.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Timetable.

  ## Examples

      iex> delete_timetable(timetable)
      {:ok, %Timetable{}}

      iex> delete_timetable(timetable)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timetable(%Timetable{} = timetable) do
    Repo.delete(timetable)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timetable changes.

  ## Examples

      iex> change_timetable(timetable)
      %Ecto.Changeset{source: %Timetable{}}

  """
  def change_timetable(%Timetable{} = timetable, attrs \\ %{}) do
    Timetable.changeset(timetable, attrs)
  end
end
