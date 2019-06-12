defmodule Travenger.Travel.Event do
  @moduledoc """
  Event schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Travel.Organizer

  @attrs ~w(title description)a

  schema "events" do
    field(:title, :string)
    field(:description, :string)

    belongs_to(:organizer, Organizer)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @attrs)
    |> validate_required([:title])
  end
end
