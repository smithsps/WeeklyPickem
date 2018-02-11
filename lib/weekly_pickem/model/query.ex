defmodule WeeklyPickem.Model.Query do
  import Ecto.Query, warn: false

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Model


  def list_teams do
    Repo.all(Model.Team)
  end

  def get_team(id) do
    Repo.get!(Model.Team, id)
  end

  def get_team_by_name(name) do
    Repo.get_by!(Model.Team, name: name)
  end

end
