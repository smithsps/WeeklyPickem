defmodule WeeklyPickemWeb.Resolvers.MatchResolver do
  import Ecto.Query

  alias WeeklyPickem.Model.Match
  alias WeeklyPickem.Model.Team

  def all_matches(_root, _args, _info) do
    matches = Match |> WeeklyPickem.Repo.all

    unique_teams = 
      matches 
      |> Enum.reduce(MapSet.new, fn(match, acc) -> 
          acc = MapSet.put(acc, match.team_one)
          MapSet.put(acc, match.team_two)
        end)
      |> MapSet.to_list
    
    teams_map = 
      Team 
      |> where([t], t.id in ^unique_teams) 
      |> WeeklyPickem.Repo.all
      |> Enum.reduce(Map.new, fn(team, acc) ->
          Map.put_new(acc, team.id, team)
          end)
      
    IO.inspect teams_map
    
    matches =
      Enum.map(matches, fn(m) -> 
        %{
          id: m.id,
          time: m.time,
          team_one: Map.get(teams_map, m.team_one),
          team_two: Map.get(teams_map, m.team_two),
          winner: Map.get(teams_map, m.winner)
        } 
      end)

    {:ok, matches}
  end
end
  