defmodule Travenger.AccountTest do
  use Travenger.DataCase

  import Travenger.Account.Factory

  alias Travenger.Account
  alias Travenger.Account.User

  describe "create_user!/1" do
    test "creates a user if not existing" do
      {:ok, user} = Account.create_user!(params_for(:user))

      assert user.id
    end

    test "updates a user if existing" do
      user = insert(:user)
      {:ok, user} = Account.create_user!(%{email: user.email})

      assert user.id
    end
  end

  describe "get_user/1" do
    test "retrieves a user by id" do
      assert %User{} = Account.get_user(insert(:user).id)
    end
  end
end
