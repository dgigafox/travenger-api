defmodule Travenger.Account.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.Account.User

  def user_factory do
    email = sequence(:email, &"email-#{&1}@example.com")

    %User{
      email: email,
      name: "Darren Gegantino",
      image_url: "http://graph.facebook.com/10216277902323229/picture?type=square",
      first_name: "Darren",
      last_name: "Gegantino",
      gender: "male",
      provider: "facebook"
    }
  end
end
