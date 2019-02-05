defmodule TravengerWeb.Middlewares.AuthenticateUser do
  @moduledoc """
  Absinthe Middleware that ensures user is authenticated
  """
  @behaviour Absinthe.Middleware

  @error_map %{
    code: :not_authenticated,
    error: "Not authenticated",
    message: "Not authenticated"
  }

  def call(resolution = %{context: %{current_user: _}}, _config) do
    resolution
  end

  def call(resolution, _config) do
    Absinthe.Resolution.put_result(resolution, {:error, @error_map})
  end
end
