defmodule WeeklyPickem.Esport.Service.TeamUpdate do

  import WeeklyPickem.Services.PandaScoreAPI

  alias WeeklyPickem.Esport.Team

  #@na_summer_split_series_id "1482"

  def update do
    teams = get_all_na_lol_teams()

    Enum.map teams, fn team ->
      %Team {
        panda_id: Integer.to_string(Map.get(team, "id")),
        name: team["name"],
        acronym: team["acronym"]
      }
      |> WeeklyPickem.Repo.insert!
      |> IO.inspect
    end
  end

  defp get_all_na_lol_teams do
    new_request("lol/teams")
    |> results_per_page("100")
    |> execute_all_pages
  end

end

# %{
#   "acronym" => "PGM",
#   "current_videogame" => %{
#     "id" => 1,
#     "name" => "LoL",
#     "slug" => "league-of-legends"
#   },
#   "id" => 2717,
#   "image_url" => "https://cdn.pandascore.co/images/team/image/2717/300px-Penguinslogo_square.png",
#   "name" => "Penguins",
#   "players" => [
#     %{
#       "first_name" => "Bartosz",
#       "id" => 9651,
#       "image_url" => "https://cdn.pandascore.co/images/player/image/9651/Babunia.jpg",
#       "last_name" => "Dzikowski",
#       "name" => "Ippon",
#       ...
#     },
#     %{
#       "first_name" => "Piotr",
#       "id" => 14968,
#       "image_url" => "https://cdn.pandascore.co/images/player/image/14968/220px-Unknown_Infobox_Image_-_Player.png",
#       "last_name" => "Dąbrowski",
#       ...
#     },
#     %{
#       "first_name" => "Ernesto",
#       "id" => 14969,
#       "image_url" => "https://cdn.pandascore.co/images/player/image/14969/220px-G2_Siler_SuperLiga_Orange_Season_12.jpeg",
#       ...
#     },
#     %{"first_name" => "Javier", "id" => 14970, ...},
#     %{"first_name" => "Hendrik", ...}
#   ]
# },
