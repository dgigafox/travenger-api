defmodule Travenger.Community.Invitation do
  @moduledoc """
  Invitation Schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Travenger.Helpers.Validators

  alias Travenger.Community.Group
  alias Travenger.Community.Member

  @valid_status ~w(pending)a

  schema "invitations" do
    field(:status, InvitationStatusEnum, default: :pending)

    field(:accepted_at, :naive_datetime)
    field(:cancelled_at, :naive_datetime)
    field(:rejected_at, :naive_datetime)

    belongs_to(:member, Member)
    belongs_to(:group, Group)

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, [])
    |> validate_required([])
  end

  def accept_changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, [:status, :accepted_at])
    |> validate_status(@valid_status)
    |> put_change(:status, :accepted)
    |> put_change(:accepted_at, DateTime.utc_now())
  end
end
