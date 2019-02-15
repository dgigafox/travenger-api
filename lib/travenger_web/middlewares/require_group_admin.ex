defmodule TravengerWeb.Middlewares.RequireGroupAdmin do
  @moduledoc """
  Absinthe Middleware that ensures user is authenticated
  """
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution
  alias Travenger.Community

  @error_map %{
    code: :not_authorized,
    error: "Not authorized",
    message: "Not authorized"
  }

  def call(%{arguments: args, context: %{current_user: user}} = resolution, _config) do
    args
    |> Map.put(:user_id, user.id)
    |> Map.put(:role, :admin)
    |> Community.find_membership()
    |> case do
      nil -> Resolution.put_result(resolution, {:error, @error_map})
      _ -> resolution
    end
  end
end
