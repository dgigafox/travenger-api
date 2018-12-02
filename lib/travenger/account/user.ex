defmodule Travenger.Account.User do
  @moduledoc """
  Account.User schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w(email name image_url first_name last_name gender)a
  @required_attrs ~w(email image_url first_name last_name)a

  schema "users" do
    # provider info
    field(:provider, :string)

    # user info
    field(:email, :string)
    field(:name, :string)
    field(:image_url, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:gender, GenderTypeEnum)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
