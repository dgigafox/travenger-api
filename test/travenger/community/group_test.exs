defmodule Travenger.Community.GroupTest do
  use ExUnit.Case, async: true

  import Travenger.Community.Factory
  alias Travenger.Community.Group

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Group.changeset(%Group{}, params_for(:group))

      assert ch.valid?
    end

    test "returns invalid" do
      ch = Group.changeset(%Group{}, %{})

      refute ch.valid?
      assert ch.errors[:name]
    end
  end
end
