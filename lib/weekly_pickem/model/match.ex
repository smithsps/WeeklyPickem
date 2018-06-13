defmodule WeeklyPickem.Model.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias WeeklyPickem.Model.Match

  schema "matches" do
    field :panda_id, :string
    field :time, :utc_datetime
    field :team_one, :id
    field :team_two, :id
    field :winner, :id

    timestamps()
  end

  @doc false
  def changeset(%Match{} = match, attrs) do
    match
    |> cast(attrs, [:time, :cutoff])
    |> validate_required([:time, :cutoff])
  end
end
