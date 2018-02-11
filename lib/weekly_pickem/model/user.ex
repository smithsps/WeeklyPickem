defmodule WeeklyPickem.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias WeeklyPickem.Model.User

  schema "users" do
    field :email, :string
    field :email_confirmation, :string
    field :name, :string
    field :password, :string
    field :password_confirmation, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_confirmation(:email, message: "Email does not match email confirmation")
    |> validate_length(:email, min: 3, message: "Email is too short to be valid")
    |> validate_format(:email, ~r/@/, message: "Email is not in valid format")
    |> validate_length(:password, min: 5, max: 255, message: "Passwords must be longer than 4 and shorter than 255 characters")
    |> validate_confirmation(:password, message: "Password does not match password confirmation")
    |> force_change(:password, Argon2.hash_pwd_salt(attrs.password))
    |> unique_constraint(:email, message: "Email has already been taken.")
  end
end
