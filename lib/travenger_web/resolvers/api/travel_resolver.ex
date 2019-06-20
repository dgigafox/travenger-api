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

  def update_event(params, _context) do
    with {:ok, event} <- find_event(Map.put(params, :id, params.event_id)) do
      Travel.update_event(event, params)
    end
  end

  def invite(params, %{context: %{current_user: user}}) do
    with {:ok, organizer} <- Travel.build_organizer_from_user(user),
         {:ok, joiner} <- find_joiner(%{id: params.joiner_id}),
         {:ok, event} <-
           find_event(%{
             id: params.event_id,
             organizer_id: organizer.id
           }) do
      Travel.invite(event, joiner)
    end
  end

  def accept_event_invitation(params, %{context: %{current_user: user}}) do
    with {:ok, joiner} <- Travel.build_joiner_from_user(user),
         {:ok, inv} <-
           find_invitation(%{
             id: params.invitation_id,
             joiner_id: joiner.id
           }) do
      Travel.accept_invitation(inv)
    end
  end

  def find_invitation(params) do
    case Travel.find_invitation(params) do
      nil -> {:error, "invitation not found"}
      inv -> {:ok, inv}
    end
  end

  defp find_joiner(params) do
    case Travel.find_joiner(params) do
      nil -> {:error, "joiner not found"}
      joiner -> {:ok, joiner}
    end
  end

  defp find_event(params) do
    case Travel.find_event(params) do
      nil -> {:error, "event not found"}
      event -> {:ok, event}
    end
  end
end
