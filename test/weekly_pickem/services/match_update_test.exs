defmodule WeeklyPickem.Services.MatchUpdatesTest do
  use ExUnit.Case
  use WeeklyPickem.DataCase

  alias WeeklyPickem.Services.MatchUpdate

  test "name is required" do
    #MatchUpdate.current_leagues()
    matches = MatchUpdate.update()

    # Enum.each matches, fn match ->
    #   teams = MapSet.new

    #   "#{match["id"]} - #{match["begin_at"]}"
    #   |> IO.inspect

    #   team_one = Enum.at(match["opponents"], 0)
    #   team_two = Enum.at(match["opponents"], 1)

    #   MapSet.put(teams, team_one["opponent"]["name"])
    #   MapSet.put(teams, team_two["opponent"]["name"])

    #   IO.inspect team_one["opponent"]["name"]

    #   #IO.inspect "#{team_one["id"]} (#{team_one["opponent"]["name"]})  v.s.  #{team_two["id"]} (#{team_two["opponent"]["name"]})"

    #   #IO.inspect Ecto.DateTime.cast!(match["begin_at"])
    # end




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



    IO.inspect matches

    WeeklyPickem.Services.TeamUpdate.update()

    assert true
  end

end
