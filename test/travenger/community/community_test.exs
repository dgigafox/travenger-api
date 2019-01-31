defmodule Travenger.CommunityTest do
  use Travenger.DataCase

  import Travenger.Community.Factory

  alias Travenger.Account
  alias Travenger.Community
  alias Travenger.Community.Membership
  alias Travenger.Repo

  def build_member_from_user do
    Account.Factory.insert(:user)
    |> Community.build_member_from_user()
    |> elem(1)
  end

  setup do
    map = %{member: build_member_from_user()}

    {:ok, map}
  end

  describe "create_group/2" do
    setup %{member: member} do
      params = %{
        name: "Travel Group Sample",
        description: "This is a sample group",
        image_url: "https://dummyimage.com/600x400/000/fff.jpg&text=Testing"
      }

      {:ok, group} = Community.create_group(member, params)

      %{group: group, member: member}
    end

    test "returns a group", c do
      assert c.group.id
      assert c.group.creator.id == c.member.id
    end

    test "returns a membership", c do
      assert Repo.get_by(
               Membership,
               member_id: c.member.id,
               group_id: c.group.id
             )
    end
  end

  describe "add_admin" do
    test "returns a membership", %{member: member} do
      group = insert(:group)
      {:ok, membership} = Community.add_admin(member, group)

      assert membership.id
      assert membership.group.id == group.id
      assert membership.member.id == member.id
      assert membership.role == :admin
    end
  end

  describe "invite" do
    test "returns a pending invitation", %{member: member} do
      group = insert(:group)
      {:ok, invitation} = Community.invite(member, group)

      assert invitation.id
      assert invitation.member_id == member.id
      assert invitation.group_id == group.id
      assert invitation.status == :pending
    end
  end

  describe "update_group" do
    test "returns an updated group" do
      group = insert(:group)
      {:ok, updated_group} = Community.update_group(group, %{name: "New #{group.name}"})

      assert group.id == updated_group.id
      assert updated_group.name == "New #{group.name}"
    end
  end
end
