defmodule TravengerWeb.GroupControllerTest do
  use TravengerWeb.ConnCase

  import Travenger.TestHelpers
  import Travenger.TravelGroup.Factory

  alias Travenger.Account.Factory, as: Account
  alias TravengerWeb.GroupView

  @missing_token_error %{"error" => "missing_authorization_token"}

  def build_user do
    Account.insert(:user)
  end

  setup do
    user = build_user()
    conn = build_user_conn(user, &build_conn/0, &put_req_header/3)

    %{conn: conn, user: user}
  end

  describe "create/2" do
    setup %{conn: conn} do
      params = params_for(:group)
      conn = post(conn, api_v1_group_path(conn, :create), params)
      %{assigns: %{group: group}} = conn

      %{group: group, conn: conn}
    end

    test "creates and returns group", %{group: group, conn: conn} do
      expected = render_json(GroupView, "show.json", %{group: group})
      assert json_response(conn, :created) == expected
    end

    test "returns error if user is not authenticated" do
      params = params_for(:group)
      conn = build_conn()
      conn = post(conn, api_v1_group_path(conn, :create), params)
      assert json_response(conn, 401) == @missing_token_error
    end
  end
end
