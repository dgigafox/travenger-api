defmodule Travenger.Travel do
  @moduledoc """
  The Travel context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries
  import Travenger.Helpers.Utils
  import Travenger.Travel.Helpers.Queries

  alias Ecto.Multi
  alias Travenger.Account.User
  alias Travenger.Repo
  alias Travenger.Travel.Event
  alias Travenger.Travel.Invitation
  alias Travenger.Travel.Joiner
  alias Travenger.Travel.Organizer
  alias Travenger.Travel.Registration

  def build_organizer_from_user(%User{} = user) do
    params = %{user_id: user.id}

    params
    |> find_organizer()
    |> create_organizer(params)
  end

  def build_joiner_from_user(%User{} = user) do
    params = %{user_id: user.id}

    params
    |> find_joiner()
    |> create_joiner(params)
  end

  def find_organizer(params) do
    Organizer
    |> where_user_id(params)
    |> Repo.one()
  end

  def find_joiner(params) do
    Joiner
    |> where_id(params)
    |> where_user_id(params)
    |> Repo.one()
  end

  def find_event(params) do
    Event
    |> join_event_organizer(params)
    |> where_id(params)
    |> where_organizer(params)
    |> where_organizer_user_id(params)
    |> Repo.one()
  end

  def create_organizer(nil, params) do
    %Organizer{}
    |> Organizer.changeset(params)
    |> Repo.insert()
  end

  def create_organizer(organizer, _), do: {:ok, organizer}

  def create_joiner(nil, params) do
    %Joiner{}
    |> Joiner.changeset(params)
    |> Repo.insert()
  end

  def create_joiner(joiner, _), do: {:ok, joiner}

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

  def invite(%Event{} = event, %Joiner{} = joiner) do
    %Invitation{
      event: event,
      joiner: joiner
    }
    |> Invitation.changeset()
    |> Repo.insert()
  end

  def accept_invitation(%Invitation{} = invitation) do
    Multi.new()
    |> Multi.run(:event, &get_assoc(&1, invitation, :event))
    |> Multi.run(:participant, &get_assoc(&1, invitation, :joiner))
    |> Multi.run(:updated_invitation, &accept_invitation(&1, invitation))
    |> Multi.run(:registration, &register(&1.event, &1.participant))
    |> Repo.transaction()
    |> case do
      {:ok, %{updated_invitation: inv}} -> {:ok, inv}
      {:error, _, ch, _} -> {:error, ch}
    end
  end

  def register(%Event{} = event, %Joiner{} = participant) do
    %Registration{
      event: event,
      participant: participant
    }
    |> Registration.changeset()
    |> Repo.insert()
  end

  def find_invitation(params) do
    Invitation
    |> where_id(params)
    |> where_joiner(params)
    |> Repo.one()
  end

  defp accept_invitation(_, %Invitation{} = invitation) do
    invitation
    |> Invitation.accept_changeset()
    |> Repo.update()
  end

  defp get_assoc(_, struct, key) do
    get_assoc(struct, key)
  end
end
