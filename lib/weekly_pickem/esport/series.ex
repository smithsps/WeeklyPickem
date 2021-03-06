defmodule WeeklyPickem.Esport.Series do
  use Ecto.Schema
  import Ecto.Changeset

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Esport.Match
  alias WeeklyPickem.Esport.Series
  alias WeeklyPickem.Pickem.PickStats

  schema "series" do
    field :name, :string
    field :start_date, :utc_datetime
    field :region, :string
    field :tag, :string

    has_many :matches, Match

    timestamps()
  end

  @doc false
  def changeset(%Series{} = series, attrs) do
    series
    |> cast(attrs, [:name, :start_date, :region, :tag])
    |> validate_required([:name, :start_date, :region, :tag])
  end

  def get_series(user_id, series_tag) do

    series = Repo.get_by!(Series, tag: series_tag)
    {:ok, matches} = Match.get_matches_by_series(user_id, series.id)
    pick_stats = PickStats.get_pick_stats_by_series(user_id, series.id)

    {:ok, 
      %{
        id: series.id,
        name: series.name,
        tag: series.tag,
        start_at: series.start_date,
        pick_stats: pick_stats,
        matches: matches
      }
    }
  end

end