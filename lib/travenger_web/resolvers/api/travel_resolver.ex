defmodule TravengerWeb.Api.TravelResolver do
  @moduledoc """
  Travel-related resolvers
  """

  alias Travenger.Travel

  def create_event(params, %{context: %{current_user: user}}) do
    with {:ok, organizer} <- Travel.build_organizer_from_user(user) do
      Travel.create_event(organizer, params)
    end
  end
end
