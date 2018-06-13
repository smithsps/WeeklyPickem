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
end
