defmodule Travenger.TravelGroupTest do
  use Travenger.DataCase

  import Travenger.Account.Factory
  alias Travenger.TravelGroup

  def build_user do
    insert(:user)
  end

  setup do
    map = %{user: build_user()}

    {:ok, map}
  end

  describe "create_group/2" do
    test "returns a group", %{user: user} do
      params = %{
        creator_id: user.id,
        name: "Travel Group Sample",
        description: "This is a sample group",
        image_url: "https://dummyimage.com/600x400/000/fff.jpg&text=Testing"
      }

      {:ok, group} = TravelGroup.create_group(params)

      assert group.id
    end
  end
end
