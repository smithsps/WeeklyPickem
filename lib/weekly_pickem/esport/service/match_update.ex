defmodule WeeklyPickem.Esport.Service.MatchUpdate do
  import Ecto.Query

  import WeeklyPickem.Services.PandaScoreAPI

  alias WeeklyPickem.Esport.Match
  alias WeeklyPickem.Esport.Team

  @na_summer_split_series_id "1482"

  # def current_leagues() do
  #   new_request("lol/series")
  #   |> range("year", "2018", "2018")
  #   |> execute
  # end

  # def current_na_leagues() do
  #   new_request("lol/series")
  #   |> search("description", "NA")
  #   |> range("year", "2018", "2018")
  #   |> execute
  # end

  # def get_teams(ids) do
  #   new_request("teams")
  #   |> filter("id", ids)
  #   |> execute
  # end

  def update_all_old_matches do 
    now = Ecto.DateTime.utc()
    old_matches = 
      WeeklyPickem.Repo.all (
        from m in "matches",
          where: ^now > m.time and is_nil(m.winner),
          select: m.id
      )
    
    Enum.each old_matches, fn id -> 
      update_match(id)
    end
  end

  def update_match(id) do
    with match = WeeklyPickem.Repo.get!(Match, id),
         updated_match = get_match_from_panda(match.panda_id),
         panda_id = Integer.to_string(updated_match["winner"]["id"]),
         winner = WeeklyPickem.Repo.get_by!(Team, panda_id: panda_id)
    do
      if winner != nil do
        match
        |> Match.changeset(%{winner: winner.id})
        |> WeeklyPickem.Repo.update! 
      end
    end
  end

  defp get_match_from_panda(panda_id) do
    new_request("/matches/" <> panda_id)
    |> execute
  end

  def get_all_matches do
    matches = get_na_summer_split_matches()

    # Eventually do something like this to query teams that we don't know.
    # found_teams =
    #   Enum.reduce(matches, MapSet.new,
    #     fn match, acc ->
    #       team_one = Enum.at(match["opponents"], 0)
    #       team_two = Enum.at(match["opponents"], 1)

    #       MapSet.put(acc, team_one["opponent"])
    #       MapSet.put(acc, team_two["opponent"])
    #     end
    #   )
    #   |> MapSet.to_list

    # Map panda_team_id to our internal team_id
    team_reverse_map = 
      Enum.reduce Team.get_all_teams, Map.new, fn team, map ->
        case team.panda_id do
          nil -> map
          panda_id -> Map.put(map, panda_id, team.id)
        end
      end


    Enum.each matches, fn match_data ->

      team_one_id = Enum.at(match_data["opponents"], 0)["id"]
      team_two_id = Enum.at(match_data["opponents"], 1)["id"]

      winner = 
        case match_data["winner"]["id"] do
          nil -> nil
          id -> Map.get(team_reverse_map, Integer.to_string(id))
        end

      %Match {
        panda_id: Integer.to_string(match_data["id"]),
        time: Ecto.DateTime.cast!(match_data["begin_at"]),
        team_one: Map.get(team_reverse_map, Integer.to_string(team_one_id)),
        team_two: Map.get(team_reverse_map, Integer.to_string(team_two_id)),
        winner: winner
      }
      |> WeeklyPickem.Repo.insert!
    end
  end

  defp get_na_summer_split_matches do
    new_request("series/" <> @na_summer_split_series_id <> "/matches")
    |> sort(["begin_at"])
    |> results_per_page("100")
    |> execute
  end
end

# %{
#   "begin_at" => "2018-06-16T21:00:00Z",
#   "games" => [
#     %{
#       "begin_at" => nil,
#       "finished" => false,
#       "id" => 195271,
#       "length" => nil,
#       "match_id" => 48394,
#       "position" => 1,
#       "winner" => %{"id" => nil, "type" => nil},
#       "winner_type" => nil
#     }
#   ],
#   "id" => 48394,
#   "league" => %{
#     "id" => 289,
#     "image_url" => "https://storage.googleapis.com/ppanda/images/league/image/289/na-lcs-g63ljv52.png",
#     "live_supported" => true,
#     "name" => "NA LCS",
#     "slug" => "league-of-legends-na-lcs",
#     "url" => "http://www.lolesports.com/en_US/na-lcs/"
#   },
#   "league_id" => 289,
#   "name" => "100-vs-TL",
#   "number_of_games" => 1,
#   "opponents" => [
#     %{
#       "id" => 1537,
#       "opponent" => %{
#         "acronym" => "100",
#         "id" => 1537,
#         "image_url" => "https://storage.googleapis.com/ppanda/images/team/image/1537/300px-100_Thieveslogo_square.png",
#         "name" => "100 Thieves"
#       },
#       "type" => "Team"
#     },
#     %{
#       "id" => 390,
#       "opponent" => %{
#         "acronym" => "TL",
#         "id" => 390,
#         "image_url" => "https://storage.googleapis.com/ppanda/images/team/image/390/team-liquid-3g983dra.png",
#         "name" => "Team Liquid"
#       },
#       "type" => "Team"
#     }
#   ],
#   "results" => [
#     %{"score" => 0, "team_id" => 1537},
#     %{"score" => 0, "team_id" => 390}
#   ],
#   "serie" => %{
#     "begin_at" => "2018-06-16T00:00:00Z",
#     "full_name" => "Summer 2018",
#     "id" => 1482,
#     "league_id" => 289,
#     "name" => "",
#     "season" => "Summer",
#     "slug" => "league-of-legends-na-lcs-summer-2018",
#     "year" => 2018
#   },
#   "serie_id" => 1482,
#   "tournament" => %{
#     "begin_at" => "2018-06-16T00:00:00Z",
#     "end_at" => "2018-09-16T00:00:00Z",
#     "id" => 1205,
#     "league_id" => 289,
#     "name" => "Regular season",
#     "serie_id" => 1482,
#     "slug" => "league-of-legends-na-lcs-na-summer-2018-regular-season",
#     "winner_id" => nil
#   },
#   "tournament_id" => 1205,
#   "updated_at" => "2018-05-02T13:30:22Z",
#   "videogame" => %{"id" => 1, "name" => "LoL", "slug" => "league-of-legends"},
#   "winner" => nil
# }
