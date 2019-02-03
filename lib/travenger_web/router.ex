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

  pipeline :authorize_user do
    plug(TravengerWeb.UserAuthPipeline)
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

  scope "/api", TravengerWeb, as: :api do
    pipe_through(:api)

    scope "/v1", as: :v1 do
      scope "/groups" do
        pipe_through(:authorize_user)
        resources("/", GroupController, only: [:create, :update])
        post("/:group_id/invite/:user_id", GroupController, :invite)
        post("/:group_id/join", GroupController, :join)
      end

      scope "/groups" do
        resources("/", GroupController, only: [:index])
      end
    end
  end
end
