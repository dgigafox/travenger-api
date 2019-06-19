defmodule Travenger.Travel.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Travel.Event
  alias Travenger.Travel.Joiner

  schema "event_invitations" do
    field(:status, EventInvitationStatusEnum, default: :pending)
    field(:accepted_at, :naive_datetime)
    field(:rejected_at, :naive_datetime)
    field(:cancelled_at, :naive_datetime)

    belongs_to(:joiner, Joiner)
    belongs_to(:event, Event)

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
