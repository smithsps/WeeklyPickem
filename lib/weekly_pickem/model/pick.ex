defmodule WeeklyPickem.Model.Pick do
  use Ecto.Schema
  import Ecto.Changeset
  alias WeeklyPickem.Model.Pick


  schema "picks" do
    field :user_id, :id
    field :match_id, :id
    field :team_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Pick{} = pick, attrs) do
    pick
    |> cast(attrs, [:user_id, :match_id, :team_id])
    |> validate_required([:user_id, :match_id, :team_id])
  end
end
