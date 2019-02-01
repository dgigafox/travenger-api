defmodule Travenger.Community.Helpers.Queries do
  @moduledoc """
  Travenger helper queries for Community context
  """

  import Ecto.Query

  def where_creator(query, %{creator_id: cid}) do
    where(query, [q], q.creator_id == ^cid)
  end

  def where_creator(query, _params), do: query
end
