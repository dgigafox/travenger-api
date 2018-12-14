defmodule Travenger.Community.MembershipTest do
  use ExUnit.Case, async: true

  import Travenger.Community.Factory
  alias Travenger.Community.Membership

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = params_for(:membership)
      ch = Membership.changeset(%Membership{}, params)

      assert ch.valid?
    end

    test "returns invalid changeset" do
      ch = Membership.changeset(%Membership{}, %{})

      refute ch.valid?
      assert ch.errors == [role: {"can't be blank", [validation: :required]}]
    end
  end
end
