defmodule TlcApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Plug.Conn
  alias TlcApp.Repo

  alias TlcApp.Accounts.User

  require Logger

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(from u in User, where: u.email != "admin@tlc.com") # ...all except Adam
  end

  def list_students do
    Repo.all(from u in User, where: u.role == ^User.student_role())
  end

  def list_active_students do
    Repo.all(from u in User, where: u.role == ^User.student_role() and u.active)
  end

  def list_staff do
    Repo.all(from u in User, where: u.role == ^User.staff_role())
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)
  def find_user(%{"email" => email, "phone" => phone}=_attrs), do: Repo.one(from u in User,
        where: u.email == ^email or u.phone == ^phone)

  defp create_user(attrs) do
    case find_user(attrs) do
      nil ->
        %User{}
        |> User.registration_changeset(attrs)
        |> Repo.insert()
      u ->
        {:ok, u}
    end
  end

  def create_student(attrs) do
    attrs = Map.merge(attrs, %{"role" => User.student_role()})
    case Map.get(attrs, "password") do
      nil -> create_user(Map.merge(attrs, %{"password" => "cafebabe"}))
      _ -> create_user(attrs)
    end
  end

  def create_staff(attrs) do
    attrs = Map.merge(attrs, %{"role" => User.staff_role()})
    case Map.get(attrs, "password") do
      nil -> create_user(Map.merge(attrs, %{"password" => "cafebabe"}))
      _ -> create_user(attrs)
    end
  end

  def create_first_user do
    count = Repo.aggregate(User, :count, :id)
    Logger.info "There are #{count} users"

    if count == 0 do
      Logger.info "Create an admin"

      create_staff(%{
        "first_name" => "First",
        "last_name" => "Adam",
        "phone" => "08125390122",
        "email" => "ukchukundah@gmail.com"
      })
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_with_password(%User{} = user, attrs) do
    user
    |> User.registration_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def signin_with_email_and_password(conn, email, pass) do
    case Repo.get_by(User, email: email) do
      %{active: true} = user ->
        cond do
          user && checkpw(pass, user.password_hash) ->
          {:ok, signin(conn, user)}
          user ->
            {:error, :unauthorized, conn}
        end

      _ ->
        dummy_checkpw()
        {:error, :inactive, conn}
    end
  end

  def signin(conn, %User{}=user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end
