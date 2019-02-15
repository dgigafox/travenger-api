defmodule TravengerWeb.Graphql.Api.MutationsTest do
  use TravengerWeb.ConnCase

  import Travenger.TestHelpers
  import Travenger.Community.Factory

  alias Travenger.Account.Factory, as: Account

  @unauthenticated_msg "Not authenticated"

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

  setup do
    {:ok, %{user: Account.insert(:user)}}
  end

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
end
