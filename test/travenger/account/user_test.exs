defmodule Travenger.Account.UserTest do
  use ExUnit.Case, async: true

  import Travenger.Account.Factory
  alias Travenger.Account.User

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = User.changeset(%User{}, params_for(:user))

      assert ch.valid?
    end

    test "returns invalid" do
      ch = User.changeset(%User{}, %{})

      refute ch.valid?
      assert ch.errors[:email]
      assert ch.errors[:image_url]
      assert ch.errors[:first_name]
      assert ch.errors[:last_name]
    end
  end
end
