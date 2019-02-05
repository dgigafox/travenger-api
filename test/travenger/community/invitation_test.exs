defmodule Travenger.Community.InvitationTest do
  use ExUnit.Case, async: true

  import Travenger.Community.Factory

  alias Travenger.Community.Invitation

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Invitation.changeset(%Invitation{}, params_for(:invitation))

      assert ch.valid?
    end
  end

  describe "accept_changeset/2" do
    test "returns a valid changeset" do
      ch = Invitation.accept_changeset(build(:invitation))

      assert ch.valid?
      assert ch.changes[:status] == :accepted
      assert ch.changes[:accepted_at]
    end

    test "returns invalid if it is not pending" do
      invitation = build(:invitation, status: :accepted)
      ch = Invitation.accept_changeset(invitation)

      refute ch.valid?
      assert ch.errors == [status: {"is already accepted", []}]
    end
  end
end
