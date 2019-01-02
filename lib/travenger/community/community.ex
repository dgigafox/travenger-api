defmodule Travenger.Community do
  @moduledoc """
  The Community context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries

  alias Ecto.Multi
  alias Travenger.Account.User
  alias Travenger.Community.Group
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
    %Group{
      creator: member
    }
    |> Group.changeset(params)
    |> Repo.insert()

    Multi.new()
    |> Multi.insert(:group, Group.changeset(%Group{creator: member}, params))
    |> Multi.run(:admin_membership, &add_admin(member, &1.group))
    |> Repo.transaction()
    |> case do
      {:ok, %{group: group}} -> {:ok, group}
      {:error, _, ch, _} -> {:error, ch}
    end
  end

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
end
