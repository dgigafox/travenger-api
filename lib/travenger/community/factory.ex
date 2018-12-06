defmodule Travenger.Community.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.Community.Group
  alias Travenger.Community.Membership

  def group_factory do
    name = sequence(:email, &"Travel Group #{&1}")

    %Group{
      name: name,
      description: "This is a sample travel group",
      image_url: "https://dummyimage.com/600x400/000/fff.jpg&text=Testing"
    }
  end

  def membership_factory do
    %Membership{
      role: :member,
      group: build(:group)
    }
  end
end
