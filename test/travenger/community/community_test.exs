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
               group_id: c.group.id,
               role: :admin
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

  describe "add_member" do
    test "returns a membership", %{member: member} do
      group = insert(:group)
      {:ok, membership} = Community.add_member(member, group)

      assert membership.id
      assert membership.group.id == group.id
      assert membership.member.id == member.id
      assert membership.role == :member
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

  describe "join_group" do
    test "returns a join request", %{member: member} do
      group = insert(:group)

      {:ok, join_request} = Community.join_group(member, group)

      assert join_request.id
      assert join_request.requester_id == member.id
      assert join_request.group_id == group.id
    end
  end

  describe "list_groups" do
    setup %{member: member} do
      insert_list(3, :group, %{creator: member})

      {:ok, %{foo: "foo"}}
    end

    test "returns a list of groups with pagination" do
      %{entries: entries} = Community.list_groups()

      refute Enum.empty?(entries)
    end

    test "filter by creator", %{member: member} do
      %{entries: entries} = Community.list_groups(%{creator_id: member.id})

      refute Enum.empty?(entries)
      assert Enum.all?(entries, &(Map.get(&1, :creator_id) == member.id))
    end
  end

  describe "accept_invitation/1" do
    setup %{member: member} do
      invitation = insert(:invitation, member: member, status: :pending)
      {:ok, accepted_invitation} = Community.accept_invitation(invitation)

      %{
        invitation: invitation,
        accepted_invitation: accepted_invitation
      }
    end

    test "returns an accepted invitation", c do
      assert c.invitation.id == c.accepted_invitation.id
      assert c.accepted_invitation.status == :accepted
      assert c.accepted_invitation.accepted_at
    end

    test "returns a membership", c do
      assert Repo.get_by(
               Membership,
               member_id: c.invitation.member_id,
               group_id: c.invitation.group_id,
               role: :member
             )
    end
  end

  describe "accept_join_request/1" do
    setup %{member: member} do
      join_request = insert(:join_request, requester: member)
      {:ok, accepted_join_request} = Community.accept_join_request(join_request)

      %{
        join_request: join_request,
        accepted_join_request: accepted_join_request
      }
    end

    test "returns an accepted join request", c do
      assert c.join_request.id == c.accepted_join_request.id
      assert c.accepted_join_request.status == :accepted
      assert c.accepted_join_request.accepted_at
    end

    test "returns a membership", c do
      assert Repo.get_by(
               Membership,
               member_id: c.join_request.requester_id,
               group_id: c.join_request.group_id,
               role: :member
             )
    end
  end
end
