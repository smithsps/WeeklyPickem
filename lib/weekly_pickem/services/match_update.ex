defmodule WeeklyPickem.Services.MatchUpdate do

  import WeeklyPickem.Services.PandaScoreAPI

  def current_leagues() do
    new_request("lol/series")
    |> range("year", "2018", "2018")
    |> execute
  end

  def current_na_leagues() do
    new_request("lol/series")
    |> search("description", "NA")
    |> range("year", "2018", "2018")
    |> execute
  end

  def na_split_matches do
    new_request("leagues/289/matches")
    |> execute
  end
end

# League Info
# %{
#   "begin_at" => "2017-08-08T19:00:00Z",
#   "description" => "2018 NA LCS Spring Split",
#   "full_name" => "Spring 2018",
#   "id" => 1333,
#   "league" => %{
#     "id" => 289,
#     "image_url" => "https://storage.googleapis.com/ppanda/images/league/image/289/na-lcs-g63ljv52.png",
#     "live_supported" => true,
#     "name" => "NA LCS",
#     "slug" => "league-of-legends-na-lcs",
#     "url" => "http://www.lolesports.com/en_US/na-lcs/"
#   },
#   "league_id" => 289,
#   "name" => "",
#   "prizepool" => nil,
#   "season" => "Spring",
#   "slug" => "league-of-legends-na-lcs-spring-2018",
#   "tournaments" => [
#     %{
#       "begin_at" => "2018-01-20T22:00:00Z",
#       "end_at" => "2018-03-19T06:00:00Z",
#       "id" => 652,
#       "league_id" => 289,
#       ...
#     },
#     %{
#       "begin_at" => "2017-08-10T22:00:00Z",
#       "end_at" => "2017-08-13T21:00:00Z",
#       "id" => 717,
#       ...
#     },
#     %{
#       "begin_at" => "2018-03-24T21:00:00Z",
#       "end_at" => "2018-04-09T02:00:00Z",
#       ...
#     }
#   ],
#   "videogame" => %{"id" => 1, "name" => "LoL", "slug" => "league-of-legends"},
#   "year" => 2018
# }
