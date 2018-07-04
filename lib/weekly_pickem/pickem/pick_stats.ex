defmodule WeeklyPickem.Pickem.PickStats do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  
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

  @spec increment_pick_stats(%Match{}) :: {:ok} | {:error}
  def increment_pick_stats(match) do
    # Increment correct picks stat
    correct_picks = from(p in Pick, where: p.match_id == ^match.id and p.team_id == ^match.winner)

    from(ps in PickStats, 
      join: p in subquery(correct_picks), 
      on: ps.user_id == p.user_id, 
      where: ps.series_id == ^match.series_id
    )
    |> Repo.update_all(update: [inc: [correct: 1]])

    # Increment total picks stat
    all_related_picks = from(p in Pick, where: p.match_id == ^match.id)

    from(ps in PickStats, 
      join: p in subquery(all_related_picks), 
      on: ps.user_id == p.user_id, 
      where: ps.series_id == ^match.series_id
    )
    |> Repo.update_all(update: [inc: [total: 1]])

    {:ok}
  end
end