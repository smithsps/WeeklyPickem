defmodule WeeklyPickem.Web.Resolvers.MatchResolver do
  import Ecto.Query

  alias WeeklyPickem.Esport.Match
  alias WeeklyPickem.Esport.Team
  alias WeeklyPickem.Pickem.Pick

  def all_matches(_root, _args, resolution) do
    with %{context: %{current_user: current_user_id}} <- resolution
    do
      # List of all matches, right now thats only Summer 2018 NA LCS.
      matches = Match |> order_by(asc: :time) |> WeeklyPickem.Repo.all

      # Find all unqiue teams in our list of matches
      unique_teams = 
        matches 
        |> Enum.reduce(MapSet.new, fn(match, acc) -> 
            acc = MapSet.put(acc, match.team_one)
            MapSet.put(acc, match.team_two)
          end)
        |> MapSet.to_list
      
      # Get all unqiue team objs and Map team.id to them
      teams_map = 
        Team 
        |> where([t], t.id in ^unique_teams) 
        |> WeeklyPickem.Repo.all
        |> Enum.reduce(Map.new, fn(team, acc) ->
             Map.put_new(acc, team.id, team)
           end)
      
      # Map match_id to current user's picks
      user_pick_map =
        Pick
        |> where([p], p.user_id == ^current_user_id)
        |> WeeklyPickem.Repo.all
        |> Enum.reduce(Map.new, fn(pick, acc) ->
             Map.put_new(acc, pick.match_id, pick)
           end)

      # Combine all of these into a comprehesive data format
      match_list =
        Enum.map(matches, fn(m) ->
          
          user_pick =
            case Map.get(user_pick_map, m.id) do
              %Pick{team_id: team_id} -> team_id
              _ -> nil
            end

          team_one = %{
            data: Map.from_struct(Map.get(teams_map, m.team_one)),
            is_winner: m.winner == m.team_one,
            is_pick: user_pick == m.team_one
          }
          
          team_two = %{
            data: Map.from_struct(Map.get(teams_map, m.team_two)),
            is_winner: m.winner == m.team_two,
            is_pick: user_pick == m.team_two
          }
          
          %{
            id: m.id,
            time: m.time,
            team_one: team_one,
            team_two: team_two,
          } 
        end)

      {:ok, match_list}
    else
      _ -> {:error, "User is not logged in."}
    end
  end
end
  