defmodule TravengerWeb.Graphql.Api.MutationsTest do
  use TravengerWeb.ConnCase

  import Travenger.TestHelpers

  alias Travenger.Account.Factory, as: Account

  @unauthenticated_msg "Not authenticated"

  @group_fields """
    id
    name
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
end
