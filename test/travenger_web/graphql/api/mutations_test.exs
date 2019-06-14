defmodule TravengerWeb.Graphql.Api.MutationsTest do
  use TravengerWeb.ConnCase

  import Travenger.TestHelpers
  import Travenger.Community.Factory

  alias Travenger.Account.Factory, as: AccountFactory
  alias Travenger.Travel.Factory, as: TravelFactory

  @unauthenticated_msg "Not authenticated"
  @unauthorized_msg "Not authorized"

  @group_fields """
    id
    name
    description
  """

  @invitation_fields """
    id
    status
    accepted_at
    cancelled_at
    rejected_at
    inserted_at
  """

  @join_request_fields """
    id
    status
    inserted_at
  """

  @event_fields """
    id
    title
    description
  """

  defp create_resp(user, query) do
    user
    |> build_user_conn(&build_conn/0, &put_req_header/3)
    |> post(@api_graphql, query_skeleton(query))
    |> json_response(200)
  end

  defp create_unauthenticated_resp(query) do
    build_conn()
    |> post(@api_graphql, query_skeleton(query))
    |> json_response(200)
  end

  defp create_user_account(_) do
    {:ok, user: AccountFactory.insert(:user)}
  end

  setup [:create_user_account]

  describe "create_group for non authenticated user" do
    test "returns error" do
      query = """
        mutation {
          create_group(name: "Group") {
            #{@group_fields}
          }
        }
      """

      [resp | _] =
        query
        |> create_unauthenticated_resp()
        |> Map.get("errors")

      assert resp["message"] == @unauthenticated_msg
    end
  end

  describe "create_group" do
    test "returns a created group", %{user: user} do
      query = """
        mutation {
          create_group(name: "Group") {
            #{@group_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("create_group")

      assert resp["id"]
    end
  end

  describe "invite_to_group for non-admin user" do
    test "returns an error", %{user: user} do
      group = insert(:group)
      member = insert(:member, user_id: user.id)
      insert(:membership, role: :member, member: member, group: group)

      query = """
        mutation {
          invite_to_group(user_id: #{user.id}, group_id: #{group.id}) {
            #{@invitation_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("errors")

      assert hd(resp)["code"] == "not_authorized"
    end
  end

  describe "invite_to_group" do
    test "returns an invitation", %{user: user} do
      group = insert(:group)
      member = insert(:member, user_id: user.id)
      insert(:membership, role: :admin, member: member, group: group)

      query = """
        mutation {
          invite_to_group(user_id: #{user.id}, group_id: #{group.id}) {
            #{@invitation_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("invite_to_group")

      assert resp["id"]
      assert resp["inserted_at"]
    end
  end

  describe "update_group" do
    test "returns an updated group", %{user: user} do
      group = insert(:group)
      member = insert(:member, user_id: user.id)
      insert(:membership, role: :admin, member: member, group: group)

      query = """
        mutation {
          update_group(
            group_id: #{group.id}
            name: "New #{group.name}",
            description: "New #{group.description}"
            ) {
            #{@group_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("update_group")

      assert resp["id"]
    end
  end

  describe "join_group" do
    test "returns a join request", %{user: user} do
      group = insert(:group)

      query = """
        mutation {
          join_group(group_id: #{group.id}) {
            #{@join_request_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("join_group")

      assert resp["id"]
    end
  end

  describe "accept_group_invitation" do
    test "returns an accepted invitation", %{user: user} do
      member = insert(:member, user_id: user.id)
      invitation = insert(:invitation, member: member)

      query = """
        mutation {
          accept_group_invitation(invitation_id: #{invitation.id}) {
            #{@invitation_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("accept_group_invitation")

      assert resp["id"]
    end
  end

  describe "accept_join_request" do
    test "returns an accepted join request", %{user: user} do
      approver = insert(:member, user_id: user.id)
      requester = insert(:member, user_id: AccountFactory.insert(:user).id)
      join_req = insert(:join_request, requester: requester, status: :pending)
      insert(:membership, group: join_req.group, member: approver, role: :admin)

      query = """
        mutation {
          accept_join_request(
            join_request_id: #{join_req.id},
            group_id: #{join_req.group_id}
            ) {
            #{@join_request_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("accept_join_request")

      assert resp["id"]
    end

    test "returns error when the user is not an admin of the group", c do
      requester = insert(:member, user_id: AccountFactory.insert(:user).id)
      join_req = insert(:join_request, requester: requester, status: :pending)

      query = """
        mutation {
          accept_join_request(
            join_request_id: #{join_req.id},
            group_id: #{join_req.group_id}
            ) {
            #{@join_request_fields}
          }
        }
      """

      [resp] =
        c.user
        |> create_resp(query)
        |> Map.get("errors")

      assert resp["message"] == @unauthorized_msg
    end
  end

  describe "create_event" do
    test "returns a created event", %{user: user} do
      query = """
        mutation {
          create_event(
            title: "Event Title",
            description: "Event Description"
          ) {
            #{@event_fields}
          }
        }
      """

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("create_event")

      assert resp["id"]
    end
  end

  describe "update_event" do
    test "returns an updated event", %{user: user} do
      organizer = TravelFactory.insert(:organizer, user_id: user.id)
      event = TravelFactory.insert(:event, organizer: organizer)

      query = update_event_query(event)

      resp =
        user
        |> create_resp(query)
        |> Map.get("data")
        |> Map.get("update_event")

      assert resp["id"]
    end

    test "returns error when user is not the organizer", %{user: user} do
      organizer =
        TravelFactory.insert(
          :organizer,
          user_id: AccountFactory.insert(:user).id
        )

      event = TravelFactory.insert(:event, organizer: organizer)

      query = update_event_query(event)

      [resp] =
        user
        |> create_resp(query)
        |> Map.get("errors")

      assert resp["message"] == @unauthorized_msg
    end

    defp update_event_query(event) do
      """
        mutation {
          update_event(
            event_id: #{event.id},
            title: "New Title",
            description: "New Description"
          ) {
            #{@event_fields}
          }
        }
      """
    end
  end
end
