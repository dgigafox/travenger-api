defmodule Travenger.Helpers.Queries do
  @moduledoc """
  Travenger generic queries
  """

  import Ecto.Query

  def where_user_id(query, %{user_id: user_id}) do
    where(query, [q], q.user_id == ^user_id)
  end
end
