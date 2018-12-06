defmodule Travenger.TravelGroupTest do
  use Travenger.DataCase

  import Travenger.TravelGroup.Factory

  alias Travenger.Account.Factory, as: Account
  alias Travenger.TravelGroup

  def build_member_from_user do
    Account.insert(:user)
    |> TravelGroup.build_member_from_user()
    |> elem(1)
  end

  setup do
    map = %{member: build_member_from_user()}

    {:ok, map}
  end

  describe "create_group/2" do
    test "returns a group", %{member: member} do
      params = %{
        name: "Travel Group Sample",
        description: "This is a sample group",
        image_url: "https://dummyimage.com/600x400/000/fff.jpg&text=Testing"
      }

      {:ok, group} = TravelGroup.create_group(member, params)

      assert group.id
      assert group.creator.id == member.id
    end
  end

  describe "add_admin" do
    test "returns a membership", %{member: member} do
      group = insert(:group)
      {:ok, membership} = TravelGroup.add_admin(member, group)

      assert membership.id
      assert membership.group.id == group.id
      assert membership.member.id == member.id
      assert membership.role == :admin
    end
  end
end
