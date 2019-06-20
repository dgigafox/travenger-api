defmodule Travenger.Travel.Invitation do
  @moduledoc """
  Invitation schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Travenger.Helpers.Validators

  alias Travenger.Travel.Event
  alias Travenger.Travel.Joiner

  @valid_status ~w(pending)a

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

  def accept_changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, [:status, :accepted_at])
    |> validate_status(@valid_status)
    |> put_change(:status, :accepted)
    |> put_change(:accepted_at, DateTime.utc_now())
  end
end
