defmodule Travenger.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Travenger.Repo

  alias Travenger.Account.User

  def upsert_user(params) do
    params
    |> get_user_by()
    |> case do
      nil -> %User{}
      user -> user
    end
    |> User.changeset(params)
    |> Repo.insert_or_update()
  end

  def get_user(id), do: Repo.get(User, id)
  def get_user_by(%{email: email}), do: Repo.get_by(User, email: email)
end
