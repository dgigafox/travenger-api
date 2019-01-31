defmodule TravengerWeb.Plugs.UserAuthPipelineTest do
  use TravengerWeb.ConnCase

  import Travenger.TestHelpers

  alias Travenger.Account.Factory, as: Account

  describe "test auth" do
    test "returns conn when there is an authorized token" do
      user = Account.insert(:user)

      conn =
        user
        |> build_user_conn(&build_conn/0, &put_req_header/3)
        |> bypass_through(TravengerWeb.Router, [:authorize_user])
        |> get("/")

      refute conn.halted
    end

    test "returns error when there is no authorized token" do
      conn =
        build_conn()
        |> bypass_through(TravengerWeb.Router, [:authorize_user])
        |> get("/")

      assert conn.halted
      assert conn.status == 401
    end
  end
end
