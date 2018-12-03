defmodule Travenger.TravelGroup.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.TravelGroup.Group

  def group_factory do
    name = sequence(:email, &"Travel Group #{&1}")

    %Group{
      name: name,
      description: "This is a sample travel group",
      image_url: "https://dummyimage.com/600x400/000/fff.jpg&text=Testing"
    }
  end
end
