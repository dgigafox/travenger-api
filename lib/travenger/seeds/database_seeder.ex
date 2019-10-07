defmodule Travenger.Seeds.DatabaseSeeder do
  @moduledoc """
  Contains functions that fills in the database with realistic data
  """

  alias Faker.{
    Address,
    Internet,
    Name
  }

  alias Travenger.Account
  alias Travenger.Travel

  @fake_activities ~w(Trekking Climbing Diving Tour Glamping Stargazing)

  def run do
    Map.new()
    |> create_users(25)
    |> create_organizers()
    |> create_events
  end

  def create_users(acc, number_of_users) do
    users =
      Enum.map(1..number_of_users, fn _ ->
        first_name = Name.first_name()
        last_name = Name.last_name()

        params = %{
          email: Internet.free_email(),
          name: first_name <> " " <> last_name,
          image_url: Internet.url(),
          gender: Enum.random([:male, :female]),
          first_name: first_name,
          last_name: last_name
        }

        {:ok, user} = Account.upsert_user(params)
        user
      end)

    Map.put(acc, :users, users)
  end

  def create_organizers(%{users: users} = acc) do
    organizers =
      Enum.map(users, fn user ->
        {:ok, organizer} = Travel.build_organizer_from_user(user)
        organizer
      end)

    Map.put(acc, :organizers, organizers)
  end

  def create_events(%{organizers: organizers} = acc) do
    events =
      Enum.map(organizers, fn organizer ->
        params = %{
          title: "#{Address.city()} #{Enum.random(@fake_activities)}",
          description: "This is a test event"
        }

        {:ok, event} = Travel.create_event(organizer, params)
        event
      end)

    Map.put(acc, :events, events)
  end
end
