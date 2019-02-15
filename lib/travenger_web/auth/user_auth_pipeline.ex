defmodule TravengerWeb.UserAuthPipeline do
  @moduledoc false

  import Plug.Conn

  use Guardian.Plug.Pipeline,
    otp_app: :my_app,
    module: Travenger.Account.Guardian,
    error_handler: TravengerWeb.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
