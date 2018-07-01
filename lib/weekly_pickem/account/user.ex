defmodule WeeklyPickem.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias WeeklyPickem.Account.User
  alias WeeklyPickem.Pickem.Pick

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string

    has_many :picks, Pick

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_confirmation(:email, required: true, message: "Email does not match email confirmation")
    |> validate_length(:email, min: 3, message: "Email is too short to be valid")
    |> validate_format(:email, ~r/@/, message: "Email is not in valid format")
    |> validate_length(:password, min: 5, max: 255, message: "Passwords must be longer than 4 and shorter than 255 characters")
    |> validate_confirmation(:password, required: true, message: "Password does not match password confirmation")
    |> force_change(:password, if Map.has_key?(attrs, :password) do Argon2.hash_pwd_salt(attrs.password) end)
    |> unique_constraint(:email, message: "Email has already been taken.")
  end
end
