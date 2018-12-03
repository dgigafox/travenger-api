defmodule Travenger.TravelGroup.GrooupTest do
  use ExUnit.Case, async: true

  import Travenger.TravelGroup.Factory
  alias Travenger.TravelGroup.Group

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Group.changeset(%Group{}, params_for(:group))

      assert ch.valid?
    end

    test "returns invalid" do
      ch = Group.changeset(%Group{}, %{})

      refute ch.valid?
      assert ch.errors[:name]
      assert ch.errors[:image_url]
    end
  end
end
