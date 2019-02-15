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

  def update_group(params, _) do
    with {:ok, group} <- find_group(params.group_id) do
      Community.update_group(group, params)
    end
  end

  def invite(params, _res) do
    with {:ok, member} <- Community.build_member_from_user(params.user_id),
         {:ok, group} <- find_group(params.group_id) do
      Community.invite(member, group)
    end
  end

  def join_group(params, %{context: %{current_user: user}}) do
    with {:ok, member} <- Community.build_member_from_user(user),
         {:ok, group} <- find_group(params.group_id) do
      Community.join_group(member, group)
    end
  end

  def accept_group_invitation(params, %{context: %{current_user: user}}) do
    with {:ok, member} <- Community.build_member_from_user(user),
         params <- Map.put(params, :id, params.invitation_id),
         params <- Map.put(params, :member_id, member.id),
         {:ok, invitation} <- find_invitation(params) do
      Community.accept_invitation(invitation)
    end
  end

  defp find_invitation(params) do
    case Community.find_invitation(params) do
      nil -> {:error, "invitation not found"}
      inv -> {:ok, inv}
    end
  end

  defp find_group(id) do
    case Community.get_group(id) do
      nil -> {:error, "group not found"}
      group -> {:ok, group}
    end
  end
end
