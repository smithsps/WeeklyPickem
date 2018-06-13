defmodule WeeklyPickemWeb.Router do
  use WeeklyPickemWeb, :router


  pipeline :browser do
    plug :accepts, ["html"]
    #plug :fetch_session
    #plug :fetch_flash
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug WeeklyPickemWeb.Session
  end

  pipeline :admin_auth do
    plug BasicAuth, use_config: {:weekly_pickem, :admin_area_config}
  end

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug,
      schema: WeeklyPickemWeb.Schema,
      interface: :simple,
      context: %{pubsub: WeeklyPickemWeb.Endpoint}
  end

  scope "/admin" do
    pipe_through :admin_auth

    get "/", WeeklyPickemWeb.AdminPageController, :index
    get "/run/team_update", WeeklyPickemWeb.AdminPageController, :team_update
    get "/run/match_update", WeeklyPickemWeb.AdminPageController, :match_update
  end

  scope "/", WeeklyPickemWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end

  if Mix.env == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: WeeklyPickemWeb.Schema
  end

end
