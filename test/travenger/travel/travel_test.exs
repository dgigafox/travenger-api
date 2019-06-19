defmodule Travenger.TravelTest do
  use Travenger.DataCase

  import Travenger.Travel.Factory

  alias Travenger.Account.Factory, as: AccountFactory
  alias Travenger.Travel

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
