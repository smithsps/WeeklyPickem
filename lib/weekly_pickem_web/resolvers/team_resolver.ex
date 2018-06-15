defmodule WeeklyPickemWeb.Resolvers.TeamResolver do
  alias WeeklyPickem.Model.Query

  def all_teams(_root, _args, _info) do
    teams = WeeklyPickem.Model.Team.get_all_teams()
    {:ok, teams}
  end

  # def get_team(_root, args, _info) do
  #   team = Query.get_team(args)
  #   {:ok, team}
  # end

end
