defmodule WeeklyPickem.Web.Router do
  use WeeklyPickem.Web, :router


  pipeline :browser do
    plug :accepts, ["html"]
    #plug :fetch_session
    #plug :fetch_flash
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug WeeklyPickem.Web.Session
  end

  pipeline :admin_auth do
    plug BasicAuth, use_config: {:weekly_pickem, :admin_area_config}
  end

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug,
      schema: WeeklyPickem.Web.Schema,
      interface: :simple,
      context: %{pubsub: WeeklyPickem.Web.Endpoint}
  end

  scope "/admin" do
    pipe_through :admin_auth

    get "/", WeeklyPickem.Web.AdminPageController, :index
    get "/run/team_update", WeeklyPickem.Web.AdminPageController, :team_update
    get "/run/match_update", WeeklyPickem.Web.AdminPageController, :match_update
    get "/run/run_migrations", WeeklyPickem.Web.AdminPageController, :run_migrations
  end

  scope "/", WeeklyPickem.Web do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end

  if Mix.env == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: WeeklyPickem.Web.Schema
  end

end
