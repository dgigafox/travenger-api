defmodule TravengerWeb.Graphql.Admin.QueriesTest do
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
end
