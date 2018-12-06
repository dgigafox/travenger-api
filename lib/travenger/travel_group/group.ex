defmodule Travenger.TravelGroup.Group do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.TravelGroup.Member

  @required_attrs ~w(name)a
  @optional_attrs ~w(description image_url)a

  schema "groups" do
    field(:description, :string)
    field(:image_url, :string)
    field(:name, :string)

    belongs_to(:creator, Member)
    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
  end
end
