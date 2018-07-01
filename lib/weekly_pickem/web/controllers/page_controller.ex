defmodule WeeklyPickem.Web.PageController do
  use WeeklyPickem.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
