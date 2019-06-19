defmodule Travenger.Travel.Joiner do
  @moduledoc """
  Joiner schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "joiners" do
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(joiner, attrs) do
    joiner
    |> cast(attrs, [])
    |> validate_required([])
  end
end
