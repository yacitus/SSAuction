defmodule SsauctionWeb.Router do
  use SsauctionWeb, :router

  # pipeline :browser do
  #   plug :accepts, ["html"]
  #   plug :fetch_session
  #   plug :fetch_flash
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers
  # end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    # pipe_through :browser # Use the default browser stack

    # get "/", PageController, :index

    pipe_through :api

    forward "/api", Absinthe.Plug,
      schema: SsauctionWeb.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: SsauctionWeb.Schema.Schema,
      # socket: SsauctionWeb.UserSocket
      interface: :simple
  end

  # Other scopes may use custom stacks.
  # scope "/api", SsauctionWeb do
  #   pipe_through :api
  # end
end
