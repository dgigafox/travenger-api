defmodule TravengerWeb.Middlewares.RequireEventOrganizer do
  @moduledoc """
  Absinthe Middleware that ensures user the organizer of the event
  """
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution
  alias Travenger.Travel

  @error_map %{
    code: :not_authorized,
    error: "Not authorized",
    message: "Not authorized"
  }

  def call(%{arguments: args, context: %{current_user: user}} = resolution, _config) do
    args
    |> Map.put(:id, args.event_id)
    |> Map.put(:user_id, user.id)
    |> Travel.find_event()
    |> case do
      nil -> Resolution.put_result(resolution, {:error, @error_map})
      _ -> resolution
    end
  end
end
