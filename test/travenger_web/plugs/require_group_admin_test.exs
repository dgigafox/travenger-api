defmodule TravengerWeb.Plugs.RequireGroupAdminTest do
  use TravengerWeb.ConnCase

  import Travenger.Community.Factory
  import Travenger.TestHelpers

  alias Travenger.Account.Factory, as: Account
  alias TravengerWeb.Plugs.RequireGroupAdmin

  describe "call/2" do
    setup do
      user = Account.insert(:user)
      invitee = Account.insert(:user)
      member = insert(:member, user_id: user.id)
      group = insert(:group)

      %{user: user, invitee: invitee, group: group, member: member}
    end

    test "returns 403 when user is not an admin of the group", c do
      params = %{member: c.member, group: c.group, role: :member}
      membership = insert(:membership, params)

      conn =
        c.user
        |> build_user_conn(&build_conn/0, &put_req_header/3)
        |> bypass_through(TravengerWeb.Router, [:authorize_user])
        |> post("/api/v1/groups/#{c.group.id}/invite/#{c.invitee.id}")
        |> RequireGroupAdmin.call(%{})

      assert conn.halted
      assert conn.status == 403
    end

    test "returns 403 when user is not associated with the group", c do
      conn =
        c.user
        |> build_user_conn(&build_conn/0, &put_req_header/3)
        |> bypass_through(TravengerWeb.Router, [:authorize_user])
        |> post("/api/v1/groups/#{c.group.id}/invite/#{c.invitee.id}")
        |> RequireGroupAdmin.call(%{})

      assert conn.halted
      assert conn.status == 403
    end

    test "returns conn if user is admin of the group", c do
      params = %{member: c.member, group: c.group, role: :admin}
      membership = insert(:membership, params)

      conn =
        c.user
        |> build_user_conn(&build_conn/0, &put_req_header/3)
        |> bypass_through(TravengerWeb.Router, [:authorize_user])
        |> post("/api/v1/groups/#{c.group.id}/invite/#{c.invitee.id}")
        |> RequireGroupAdmin.call(%{})

      refute conn.halted
    end
  end
end
