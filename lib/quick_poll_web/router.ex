defmodule QuickPollWeb.Router do
  use QuickPollWeb, :router

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

  scope "/", QuickPollWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/polls", PollController, only: [:index, :new, :show, :create]
    post "/polls/:id/vote", PollController, :vote
    get "/polls/:id/results", PollController, :results
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: QuickPollWeb.Schema.Schema,
      interface: :simple,
      socket: QuickPollWeb.UserSocket

    forward "/", Absinthe.Plug, schema: QuickPollWeb.Schema.Schema
  end
end
