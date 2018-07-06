defmodule WeeklyPickem.Esport.TeamStats do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  
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

  @doc false
  def changeset(%TeamStats{} = team_stats, attrs) do
    team_stats
    |> cast(attrs, [:team_id, :series_id, :wins, :total])
    |> validate_required([:team_id, :series_id, :wins, :total])
  end

  @spec increment_team_stats(%Match{}) :: {:ok} | {:error}
  def increment_team_stats(match) do
    winner = match.winner

    loser = cond do
      match.team_one != winner -> match.team_one
      match.team_two != winner -> match.team_two 
    end

    # Increment winner's stats
    from(ts in TeamStats, 
      where: ^winner == ts.team_id and ^match.series_id == ts.series_id,
      update: [inc: [wins: 1, total: 1]]
    )
    |> Repo.update_all([])

    # Increment loser's stats
    from(ts in TeamStats, 
      where: ^loser == ts.team_id and ^match.series_id == ts.series_id,
      update: [inc: [total: 1]]
    )
    |> Repo.update_all([])

    {:ok}
  end
end