defmodule Travenger.Community.JoinRequest do
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Community.Group
  alias Travenger.Community.Member

  schema "join_requests" do
    field(:status, JoinRequestStatusEnum, default: :pending)

    belongs_to(:requester, Member)
    belongs_to(:group, Group)

    timestamps()
  end

  @doc false
  def changeset(join_request, attrs \\ %{}) do
    join_request
    |> cast(attrs, [])
    |> validate_required([])
  end
end
