defmodule Travenger.Community do
  @moduledoc """
  The Community context.
  """

  import Ecto.Query, warn: false
  import Travenger.Community.Helpers.Queries
  import Travenger.Helpers.Queries

  alias Ecto.Multi
  alias Travenger.Account.User
  alias Travenger.Community.Group
  alias Travenger.Community.Invitation
  alias Travenger.Community.JoinRequest
  alias Travenger.Community.Member
  alias Travenger.Community.Membership
  alias Travenger.Repo

  def build_member_from_user(%User{} = user) do
    params = %{user_id: user.id}

    case find_member(params) do
      nil -> Repo.insert(Member.changeset(%Member{}, params))
      member -> {:ok, member}
    end
  end

  def create_group(%Member{} = member, params) do
    Multi.new()
    |> Multi.insert(:group, Group.changeset(%Group{creator: member}, params))
    |> Multi.run(:admin_membership, &add_admin(member, &1.group))
    |> Repo.transaction()
    |> case do
      {:ok, %{group: group}} -> {:ok, group}
      {:error, _, ch, _} -> {:error, ch}
    end
  end

  def get_group(id), do: Repo.get(Group, id)

  def add_admin(%Member{} = member, %Group{} = group) do
    %Membership{
      member: member,
      group: group
    }
    |> Membership.changeset(%{role: :admin})
    |> Repo.insert()
  end

  def find_member(params) do
    Member
    |> where_user_id(params)
    |> Repo.one()
  end

  def invite(%Member{} = member, %Group{} = group) do
    %Invitation{
      member: member,
      group: group
    }
    |> Invitation.changeset()
    |> Repo.insert()
  end

  def find_membership(params) do
    Membership
    |> join_membership_member(params)
    |> where_member_user_id(params)
    |> where_role(params)
    |> where_group_id(params)
    |> Repo.one()
  end

  def update_group(%Group{} = group, params) do
    group
    |> Group.update_changeset(params)
    |> Repo.update()
  end

  def join_group(%Member{} = member, %Group{} = group) do
    %JoinRequest{
      requester: member,
      group: group
    }
    |> JoinRequest.changeset()
    |> Repo.insert()
  end

  def list_groups(params \\ %{}) do
    Group
    |> where_creator(params)
    |> Repo.paginate(params)
  end
end
