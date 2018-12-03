defmodule Travenger.TravelGroup do
  @moduledoc """
  The TravelGroup context.
  """

  import Ecto.Query, warn: false
  alias Travenger.Repo

  alias Travenger.TravelGroup.Group

  def create_group(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end
end
