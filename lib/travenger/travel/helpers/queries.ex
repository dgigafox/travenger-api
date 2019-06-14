defmodule Travenger.Travel.Helpers.Queries do
  @moduledoc """
  Travenger helper queries for Travel context
  """

  import Ecto.Query

  def join_event_organizer(query, _params) do
    join(query, :inner, [q], _ in assoc(q, :organizer))
  end

  def where_organizer_user_id(query, %{user_id: uid}) do
    where(query, [_e, o], o.user_id == ^uid)
  end

  def where_organizer_user_id(query, _), do: query
end
