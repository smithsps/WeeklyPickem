defmodule WeeklyPickem.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Account.User
  alias WeeklyPickem.Pickem.Pick
  alias WeeklyPickem.Pickem.PickStats
  alias WeeklyPickem.Esport.Series

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

  def get_user_profile(user_id) do
    with {:ok, user} <- Repo.get(User, user_id)
    do
      {:ok, user}
    else
      _ -> {:error, "User does not exist."}
    end
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_series_user_stats(series_tag) do
    series = Repo.get_by!(Series, tag: series_tag)

    query = from u in User,
      left_join: ps in PickStats, on: u.id == ps.user_id,
      where: ps.series_id == ^series.id,
      select: %{user: u, stats: ps}

    user_list = Enum.map(Repo.all(query), fn(q) -> 
      %{
        id: q.user.id,
        name: q.user.name,
        stats: %{
          id: q.stats.id,
          correct: q.stats.correct,
          total: q.stats.total
        }
      }
    end)

    {:ok, user_list}
  end
end
