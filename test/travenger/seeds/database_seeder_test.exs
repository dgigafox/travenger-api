defmodule Travenger.Seeds.DatabaseSeederTest do
  use Travenger.DataCase, async: true

  import Travenger.Seeds.DatabaseSeeder
  import Travenger.Travel.Factory

  alias Travenger.Account.Factory, as: AccountFactory
  alias Travenger.Account.User
  alias Travenger.Travel.Event
  alias Travenger.Travel.Organizer

  describe "creates dummy records" do
    test "run/0" do
      assert %{users: _users, organizers: _organizers, events: events} = run()
    end
    test "create_users/2" do
      %{users: users} = create_users(%{}, 10)
      recorded_users = Repo.all(User)

      assert length(users) == length(recorded_users)
    end

    test "create_organizers/2" do
      users = AccountFactory.insert_list(10, :user)
      %{organizers: organizers} = create_organizers(%{users: users})
      recorded_organizers = Repo.all(Organizer)

      assert length(organizers) == length(recorded_organizers)
    end

    test "create_events/2" do
      organizers = insert_list(10, :organizer)
      %{events: events} = create_events(%{organizers: organizers})
      recorded_events = Repo.all(Event)

      assert length(events) == length(recorded_events)
    end
  end
end
