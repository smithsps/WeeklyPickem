defmodule WeeklyPickem.Web.Resolvers.TeamResolver do
  alias WeeklyPickem.Esport.Team

  def all_teams(_root, _args, _info) do
    teams = Team.get_all_teams()
    {:ok, teams}
  end

end
