defmodule Travenger.TravelGroup.Member do
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Account.User
  alias Travenger.TravelGroup.Membership

  schema "members" do
    belongs_to(:user, User)
    has_many(:memberships, Membership)

    timestamps()
  end

  @doc false
  def changeset(member, attrs \\ %{}) do
    member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
