defmodule Travenger.Account.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.Account.User

  def user_factory do
    email = sequence(:email, &"email-#{&1}@example.com")

    %User{
      email: email
    }
  end
end
