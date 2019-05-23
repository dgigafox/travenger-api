defmodule Travenger.Community.JoinRequest do
  @moduledoc """
  Join request schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Travenger.Helpers.Validators

  alias Travenger.Community.Group
  alias Travenger.Community.Member

  @valid_status ~w(pending)a

  schema "join_requests" do
    field(:status, JoinRequestStatusEnum, default: :pending)

    belongs_to(:requester, Member)
    belongs_to(:group, Group)

    field(:accepted_at, :naive_datetime)
    field(:cancelled_at, :naive_datetime)
    field(:rejected_at, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(join_request, attrs \\ %{}) do
    join_request
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
