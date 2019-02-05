defmodule TravengerWeb.GroupControllerTest do
  use TravengerWeb.ConnCase

  import Travenger.TestHelpers
  import Travenger.Community.Factory

  alias Travenger.Account.Factory, as: Account
  alias TravengerWeb.GroupView
  alias TravengerWeb.InvitationView
  alias TravengerWeb.JoinRequestView

  @page_fields %{"page_size" => 20, "page_number" => 1}

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
  end

  describe "invite/2" do
    setup %{conn: conn, user: user} do
      invitee = Account.insert(:user)

      member = insert(:member, user_id: user.id)

      group = insert(:group)
      insert(:membership, group: group, member: member, role: :admin)

      conn = post(conn, api_v1_group_path(conn, :invite, group.id, invitee.id))
      %{assigns: %{invitation: inv}} = conn
      %{invitation: inv, conn: conn}
    end

    test "creates and returns an invitation", %{invitation: inv, conn: conn} do
      expected = render_json(InvitationView, "show.json", %{invitation: inv})
      assert json_response(conn, :created) == expected
    end
  end

  describe "update/2" do
    test "returns 200", %{conn: conn, user: user} do
      group = insert(:group)
      member = insert(:member, user_id: user.id)
      insert(:membership, group: group, member: member, role: :admin)

      conn = put(conn, api_v1_group_path(conn, :update, group.id), %{name: "New Name"})
      %{assigns: %{group: group}} = conn

      expected = render_json(GroupView, "show.json", %{group: group})
      assert json_response(conn, :ok) == expected
    end
  end

  describe "join_request/2" do
    test "returns 200", %{conn: conn} do
      group = insert(:group)

      conn = post(conn, api_v1_group_path(conn, :join, group.id))
      %{assigns: %{join_request: joinreq}} = conn

      expected = render_json(JoinRequestView, "show.json", %{join_request: joinreq})
      assert json_response(conn, :ok) == expected
    end
  end

  describe "index/2" do
    test "returns a paginated list of groups" do
      insert_list(3, :group)
      conn = build_conn()
      conn = get(conn, api_v1_group_path(conn, :index), @page_fields)
      %{"data" => data} = json_response(conn, :ok)

      assert data["page_number"] == @page_fields["page_number"]
      assert data["page_size"] == @page_fields["page_size"]
      assert data["total_entries"] == 3
      assert data["total_pages"] == 1
      refute data["entries"] == []
    end
  end

  describe "show/2" do
    test "returns a group", %{conn: conn} do
      group = insert(:group)
      conn = get(conn, api_v1_group_path(conn, :show, group.id))
      %{"data" => data} = json_response(conn, :ok)

      assert data["id"]
    end
  end

  describe "accept_invitation/2" do
    test "returns an accepted invitation", %{conn: conn, user: user} do
      member = insert(:member, user_id: user.id)
      invitation = insert(:invitation, member: member)
      path = api_v1_group_path(conn, :accept_invitation, invitation.id)
      conn = put(conn, path)
      %{"data" => data} = json_response(conn, :ok)

      assert data["id"]
      assert data["status"]
      assert data["accepted_at"]
    end
  end
end
