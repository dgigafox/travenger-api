defmodule TravengerWeb.Api.CommunityResolver do
  @moduledoc """
  Community-related resolvers
  """

  alias Travenger.Community

  def list_groups(params, _res) do
    {:ok, Community.list_groups(params)}
  end

  def create_group(params, %{context: %{current_user: user}}) do
    with {:ok, member} <- Community.build_member_from_user(user) do
      Community.create_group(member, params)
    end
  end
end
