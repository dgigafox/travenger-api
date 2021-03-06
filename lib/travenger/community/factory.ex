defmodule Travenger.Community.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.Community.Group
  alias Travenger.Community.Invitation
  alias Travenger.Community.JoinRequest
  alias Travenger.Community.Member
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
      group: build(:group),
      member: build(:member)
    }
  end

  def member_factory do
    %Member{
      user_id: sequence(:user_id, & &1)
    }
  end

  def invitation_factory do
    %Invitation{
      member: build(:member),
      group: build(:group)
    }
  end

  def join_request_factory do
    %JoinRequest{
      requester: build(:member),
      group: build(:group)
    }
  end
end
