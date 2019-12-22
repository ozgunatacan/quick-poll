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
  end

  # Other scopes may use custom stacks.
  # scope "/api", QuickPollWeb do
  #   pipe_through :api
  # end
end
