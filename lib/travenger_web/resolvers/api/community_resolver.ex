defmodule TravengerWeb.Api.CommunityResolver do
  @moduledoc """
  Community-related resolvers
  """

  alias Travenger.Community

  def list_groups(params, _res) do
    {:ok, Community.list_groups(params)}
  end
end
