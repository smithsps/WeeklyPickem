defmodule WeeklyPickemWeb.AdminPageController do
  use WeeklyPickemWeb, :controller

  plug :put_layout, "app.html"
  plug :put_view, WeeklyPickemWeb.PageView


  def index(conn, _params) do
    render conn, "admin.html"
  end

  def team_update(conn, _params) do
    WeeklyPickem.Services.TeamUpdate.update()
    text conn, "Success: Ran Team Update Service!"
  end

  def match_update(conn, _params) do
    WeeklyPickem.Services.MatchUpdate.update()
    text conn, "Success: Ran Match Update Service!"
  end

  def run_migrations(conn, _params) do
    Ecto.Migrator.run(WeeklyPickem.Repo, migrations_path(WeeklyPickem.Repo), :up, all: true)
    text conn, "Success: Ran ecto migrator!"
  end


  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split |> List.last |> Macro.underscore
    Path.join([priv_dir(app), repo_underscore, filename])
  end
end
