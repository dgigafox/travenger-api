defmodule TravengerWeb.AuthErrorHandlerTest do
  use TravengerWeb.ConnCase

  alias TravengerWeb.AuthErrorHandler

  @missing_auth %{"error" => "missing_authorization_token"}
  @invalid_token %{"error" => "invalid_token"}

  describe "auth_error/3" do
    test "returns missing authorization token error" do
      conn =
        AuthErrorHandler.auth_error(
          build_conn(),
          {:no_resource_found, ""},
          []
        )

      assert conn.status == 401
      assert json_response(conn, 401) == @missing_auth
    end

    test "returns invalid token error" do
      conn =
        AuthErrorHandler.auth_error(
          build_conn(),
          {:invalid_token, ""},
          []
        )

      assert conn.status == 401
      assert json_response(conn, 401) == @invalid_token
    end
  end
end
