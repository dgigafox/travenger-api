defmodule TravengerWeb.Middlewares.AuthenticateUser do
  @moduledoc """
  Absinthe Middleware that ensures user is authenticated
  """
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  @error_map %{
    code: :not_authenticated,
    error: "Not authenticated",
    message: "Not authenticated"
  }

  def call(%{context: %{current_user: _}} = resolution, _config) do
    resolution
  end

  def call(resolution, _config) do
    Resolution.put_result(resolution, {:error, @error_map})
  end
end
