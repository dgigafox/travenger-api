defmodule Travenger.Travel do
  @moduledoc """
  The Travel context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries
  import Travenger.Travel.Helpers.Queries

  alias Travenger.Account.User
  alias Travenger.Repo
  alias Travenger.Travel.Event
  alias Travenger.Travel.Organizer

  def build_organizer_from_user(%User{} = user) do
    params = %{user_id: user.id}

    params
    |> find_organizer()
    |> create_organizer(params)
  end

  def find_organizer(params) do
    Organizer
    |> where_user_id(params)
    |> Repo.one()
  end

  def find_event(params) do
    Event
    |> join_event_organizer(params)
    |> where_id(params)
    |> where_organizer_user_id(params)
    |> Repo.one()
  end

  def create_organizer(nil, params) do
    %Organizer{}
    |> Organizer.changeset(params)
    |> Repo.insert()
  end

  def create_event(%Organizer{} = organizer, params) do
    %Event{organizer: organizer}
    |> Event.changeset(params)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, params) do
    event
    |> Event.changeset(params)
    |> Repo.update()
  end
end
