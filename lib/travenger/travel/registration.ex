defmodule Travenger.Travel.Registration do
  @moduledoc """
  Registration schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Travel.Event
  alias Travenger.Travel.Joiner

  schema "event_registrations" do
    field(:status, EventRegistrationStatusEnum, default: :confirmed)

    belongs_to(:event, Event)
    belongs_to(:participant, Joiner)
    timestamps()
  end

  @doc false
  def changeset(event_registration, attrs \\ %{}) do
    event_registration
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
