defmodule WeeklyPickemWeb.Router do
  use WeeklyPickemWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WeeklyPickemWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  if Mix.env == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: WeeklyPickemWeb.Schema
  end

  pipeline :graphql do
    plug WeeklyPickemWeb.Context
  end

  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: WeeklyPickemWeb.Schema,
      interface: :simple,
      context: %{pubsub: WeeklyPickemWeb.Endpoint}
  end

end
