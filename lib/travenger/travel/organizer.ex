defmodule Travenger.Travel.Organizer do
  @moduledoc """
  Event organizer schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Travel.Event

  schema "organizers" do
    field(:user_id, :id)

    has_many(:events, Event)

    timestamps()
  end

  @doc false
  def changeset(member, attrs \\ %{}) do
    member
    |> cast(attrs, ~w(user_id)a)
    |> validate_required([])
  end
end
