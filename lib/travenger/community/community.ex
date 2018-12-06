defmodule Travenger.Community do
  @moduledoc """
  The Community context.
  """

  import Ecto.Query, warn: false
  alias Travenger.Repo

  alias Travenger.Account.User
  alias Travenger.Community.Group
  alias Travenger.Community.Member
  alias Travenger.Community.Membership

  def build_member_from_user(%User{} = user) do
    %Member{
      user: user
    }
    |> Member.changeset()
    |> Repo.insert()
  end

  def create_group(%Member{} = member, params) do
    %Group{
      creator: member
    }
    |> Group.changeset(params)
    |> Repo.insert()
  end

  def add_admin(%Member{} = member, %Group{} = group) do
    %Membership{
      member: member,
      group: group
    }
    |> Membership.changeset(%{role: :admin})
    |> Repo.insert()
  end
end
