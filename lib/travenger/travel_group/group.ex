defmodule Travenger.TravelGroup.Group do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_attrs ~w(name image_url)a
  @optional_attrs ~w(description)a

  schema "groups" do
    field(:description, :string)
    field(:image_url, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
  end
end
