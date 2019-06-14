defmodule Travenger.TravelTest do
  use Travenger.DataCase

  alias Travenger.Account.Factory, as: AccountFactory
  alias Travenger.Travel

  setup [:build_organizer_from_user]

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

  defp build_organizer_from_user(_) do
    organizer =
      :user
      |> AccountFactory.insert()
      |> Travel.build_organizer_from_user()
      |> elem(1)

    {:ok, organizer: organizer}
  end
end
