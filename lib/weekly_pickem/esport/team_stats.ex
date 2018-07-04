defmodule WeeklyPickem.Esport.TeamStats do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  
  alias WeeklyPickem.Repo
  alias WeeklyPickem.Esport.Match
  alias WeeklyPickem.Esport.TeamStats


  schema "team_stats" do
    field :team_id, :id
    field :series_id, :id
    field :wins, :id
    field :total, :id

    timestamps()
  end

  @spec increment_team_stats(%Match{}) :: {:ok} | {:error}
  def increment_team_stats(match) do
    winner = match.winner

    loser = cond do
      match.team_one != winner -> match.team_one
      match.team_two != winner -> match.team_two 
    end

    # Increment winner's stats
    from(ts in TeamStats, where: ^winner == ts.team_id and ^match.series_id == ts.series_id)
    |> Repo.update(update: [inc: [wins: 1, total: 1]])

    # Increment loser's stats
    from(ts in TeamStats, where: ^loser == ts.team_id and ^match.series_id == ts.series_id)
    |> Repo.update(update: [inc: [total: 1]])
  end
end