defmodule TlcApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @student "student"
  @staff "staff"

  @derive {Jason.Encoder, only: [:id, :active, :first_name, :last_name, :email, :phone, :role]}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: @student
    field :email, :string
    field :active, :boolean, default: true

    timestamps()
  end

  @fields [:email, :first_name, :last_name, :phone, :password, :role, :active]
  @required_fields [:email, :first_name, :last_name, :phone]

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:role, [@staff, @student])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
  end

  def registration_changeset(%__MODULE__{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash
  end

  def student_role, do: @student
  def staff_role, do: @staff

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
