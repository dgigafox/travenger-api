defmodule Travenger.Community.Member do
  @moduledoc """
  Community member schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Account.User
  alias Travenger.Community.Membership

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
