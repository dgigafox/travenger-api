defmodule Travenger.TravelTest do
  use Travenger.DataCase

  import Travenger.Travel.Factory

  alias Travenger.Account.Factory, as: AccountFactory
  alias Travenger.Repo
  alias Travenger.Travel
  alias Travenger.Travel.Registration

  setup [:build_organizer_from_user, :build_joiner_from_user]

  describe "create_event" do
    test "can create event", %{organizer: organizer} do
      params = %{
        title: "Test Event",
        description: "Test Event Description"
      }

      {:ok, event} = Travel.create_event(organizer, params)

      assert event.id
    end
  end

  describe "update_event" do
    test "can update event", %{organizer: organizer} do
      event = insert(:event, organizer: organizer)

      params = %{
        title: "New Test Event",
        description: "New Test Event Description"
      }

      {:ok, event} = Travel.update_event(event, params)

      assert event.title == params.title
      assert event.description == params.description
    end
  end

  describe "invite" do
    test "can invite a joiner", %{joiner: joiner, organizer: organizer} do
      event = insert(:event, organizer: organizer)

      {:ok, invitation} = Travel.invite(event, joiner)

      assert invitation.id
      assert invitation.status == :pending
      assert invitation.joiner_id == joiner.id
      assert invitation.event_id == event.id
    end
  end

  describe "accept_invitation" do
    setup %{organizer: organizer, joiner: joiner} do
      event = insert(:event, organizer: organizer)
      invitation = insert(:event_invitation, event: event, joiner: joiner)

      {:ok, invitation} = Travel.accept_invitation(invitation)

      %{
        invitation: invitation,
        event: event,
        joiner: joiner
      }
    end

    test "returns an accepted invitation", c do
      assert c.invitation.status == :accepted
      assert c.invitation.joiner.id == c.joiner.id
      assert c.invitation.event.id == c.event.id
    end

    test "returns a confirmed registration", %{invitation: invitation} do
      assert Repo.get_by(Registration,
               event_id: invitation.event.id,
               participant_id: invitation.joiner.id,
               status: :confirmed
             )
    end
  end

  defp build_organizer_from_user(_) do
    organizer =
      :user
      |> AccountFactory.insert()
      |> Travel.build_organizer_from_user()
      |> elem(1)

    {:ok, organizer: organizer}
  end

  defp build_joiner_from_user(_) do
    joiner =
      :user
      |> AccountFactory.insert()
      |> Travel.build_joiner_from_user()
      |> elem(1)

    {:ok, joiner: joiner}
  end
end
