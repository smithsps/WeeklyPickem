defmodule WeeklyPickem.Esport.Match do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Esport.Match
  alias WeeklyPickem.Esport.Team
  alias WeeklyPickem.Esport.TeamStats
  alias WeeklyPickem.Pickem.Pick

  schema "matches" do
    field :panda_id, :string
    field :series_id, :id
    field :time, :utc_datetime
    field :team_one, :id
    field :team_two, :id
    field :winner, :id

    timestamps()
  end

  @doc false
  def changeset(%Match{} = match, attrs) do
    match
    |> cast(attrs, [:panda_id, :time, :team_one, :team_two, :winner])
    |> validate_required([:panda_id, :time, :team_one, :team_two, :winner])
  end


  def get_matches_by_series(user_id, series_id) do

    query = from m in Match,
      left_join: t1 in Team, on: t1.id == m.team_one,
      left_join: t1s in TeamStats, on: t1s.team_id == t1.id,
      left_join: t2 in Team, on: t2.id == m.team_two,
      left_join: t2s in TeamStats, on: t2s.team_id == t2.id,
      left_join: p in Pick, on: p.match_id == m.id, 
      where: p.user_id == ^user_id or is_nil(p.user_id),
      where: m.series_id == ^series_id,
      order_by: m.time,
      select: %{match: m, team1: t1, team1_stats: t1s, team2: t2, team2_stats: t2s, pick: p}




    match_list = Enum.map(Repo.all(query), fn(q) -> 
      %{
        id: q.match.id,
        time: q.match.time,
        team_one: %{
          data: Map.put(Map.from_struct(q.team1), :stats, Map.from_struct(q.team1_stats)),
          is_winner: not is_nil(q.match.winner) and q.match.winner == q.team1.id,
          is_pick: not is_nil(q.pick) and q.pick.team_id == q.team1.id
        },
        team_two: %{
          data: Map.put(Map.from_struct(q.team2), :stats, Map.from_struct(q.team2_stats)),
          is_winner: not is_nil(q.match.winner) and q.match.winner == q.team2.id,
          is_pick: not is_nil(q.pick) and q.pick.team_id == q.team2.id
        }
      }
    end)
    
    {:ok, match_list}
  end
end
