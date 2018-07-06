defmodule WeeklyPickem.Pickem.PickStats do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  
  alias WeeklyPickem.Repo
  alias WeeklyPickem.Esport.Match
  alias WeeklyPickem.Pickem.Pick
  alias WeeklyPickem.Pickem.PickStats 


  schema "pick_stats" do
    field :user_id, :id
    field :series_id, :id
    field :correct, :integer
    field :total, :integer

    timestamps()
  end

  @doc false
  def changeset(%PickStats{} = pick_stats, attrs) do
    pick_stats
    |> cast(attrs, [:user_id, :series_id, :correct, :total])
    |> validate_required([:user_id, :series_id, :correct, :total])
  end

  @spec increment_pick_stats(%Match{}) :: {:ok} | {:error}
  def increment_pick_stats(match) do
    # Increment correct picks stat
    correct_picks = from(p in Pick, where: p.match_id == ^match.id and p.team_id == ^match.winner)

    from(ps in PickStats, 
      join: p in subquery(correct_picks), 
      on: ps.user_id == p.user_id, 
      where: ps.series_id == ^match.series_id,
      update: [inc: [correct: 1]]
    )
    |> Repo.update_all([])

    # Increment total picks stat
    all_related_picks = from(p in Pick, where: p.match_id == ^match.id)

    from(ps in PickStats, 
      join: p in subquery(all_related_picks), 
      on: ps.user_id == p.user_id, 
      where: ps.series_id == ^match.series_id,
      update: [inc: [total: 1]]
    )
    |> Repo.update_all([])

    {:ok}
  end

  def get_pick_stats_by_series(user_id, series_id) do
    Repo.get_by(PickStats, %{user_id: user_id, series_id: series_id} )
  end
end