defmodule WeeklyPickemWeb.PageController do
  use WeeklyPickemWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
