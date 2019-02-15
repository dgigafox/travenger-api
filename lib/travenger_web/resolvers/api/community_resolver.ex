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

  def invite(params, _res) do
    with {:ok, member} <- Community.build_member_from_user(params.user_id),
         {:ok, group} <- find_group(params.group_id) do
      Community.invite(member, group)
    end
  end

  defp find_group(id) do
    case Community.get_group(id) do
      nil -> {:error, "group not found"}
      group -> {:ok, group}
    end
  end
end
