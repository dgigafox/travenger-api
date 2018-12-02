defmodule TravengerWeb.Router do
  use TravengerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TravengerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TravengerWeb do
  #   pipe_through :api
  # end

  scope "/auth", TravengerWeb do
    pipe_through(:api)

    get("/:provider", AccountController, :request)
    get("/:provider/callback", AccountController, :callback)
  end
end
