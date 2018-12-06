defmodule Travenger.Community.Membership do
  @moduledoc """
  Membership schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Community.Group
  alias Travenger.Community.Member
  alias Travenger.Community.Membership

  @required_attrs ~w(role)a

  schema "memberships" do
    field(:role, RoleTypeEnum)

    belongs_to(:member, Member)
    belongs_to(:group, Group)

    has_many(:memberships, Membership)

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
  end
end
