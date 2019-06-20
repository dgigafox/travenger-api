defmodule Travenger.Travel.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.Travel.Event
  alias Travenger.Travel.Invitation
  alias Travenger.Travel.Joiner
  alias Travenger.Travel.Organizer

  def organizer_factory do
    %Organizer{
      user_id: sequence(:user_id, & &1)
    }
  end

  def joiner_factory do
    %Joiner{
      user_id: sequence(:user_id, & &1)
    }
  end

  def event_factory do
    title = sequence(:email, &"Travel Event #{&1}")

    %Event{
      title: title,
      description: "This is a sample travel group",
      organizer: build(:organizer)
    }
  end

  def event_invitation_factory do
    %Invitation{
      joiner: build(:joiner),
      event: build(:event)
    }
  end
end
