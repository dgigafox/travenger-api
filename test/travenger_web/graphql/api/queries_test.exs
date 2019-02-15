defmodule TravengerWeb.Graphql.Api.QueriesTest do
  use TravengerWeb.ConnCase

  import Travenger.Community.Factory
  import Travenger.TestHelpers

  alias Travenger.Account.Factory, as: Account

  @page_fields "page: 1, page_size: 10"

  @group_fields """
    id
    name
    description
  """

  defp create_unauthenticated_resp(query) do
    build_conn()
    |> post(@api_graphql, query_skeleton(query))
    |> json_response(200)
  end

  setup do
    {:ok, %{user: Account.insert(:user)}}
  end

  describe "groups" do
    test "returns paginated groups" do
      insert_list(5, :group)

      query = """
        query {
          groups(#{@page_fields}) {
            entries {
              #{@group_fields}
            }
          }
        }
      """

      resp =
        query
        |> create_unauthenticated_resp()
        |> Map.get("data")
        |> Map.get("groups")
        |> Map.get("entries")

      refute Enum.empty?(resp)
    end
  end

  describe "group" do
    test "returns a group" do
      group = insert(:group)

      query = """
        query {
          group(id: #{group.id}) {
            #{@group_fields}
          }
        }
      """

      resp =
        query
        |> create_unauthenticated_resp()
        |> Map.get("data")
        |> Map.get("group")

      assert resp["id"]
    end
  end
end
