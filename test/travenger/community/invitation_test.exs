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
end
