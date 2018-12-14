defmodule Travenger.Community.Member do
  @moduledoc """
  Community member schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Community.Membership

  schema "members" do
    field(:user_id, :id)
    has_many(:memberships, Membership)

    timestamps()
  end

  @doc false
  def changeset(member, attrs \\ %{}) do
    member
    |> cast(attrs, ~w(user_id)a)
    |> validate_required([])
  end
end
