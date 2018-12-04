defmodule TravengerWeb.AuthErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status(type), Poison.encode!(%{error: errors(type)}))
  end

  defp errors(type) do
    case type do
      :no_resource_found -> :missing_authorization_token
      :invalid_token -> :invalid_token
    end
  end

  defp status(type) do
    case type do
      :no_resource_found -> :unauthorized
      :invalid_token -> :unauthorized
    end
  end
end
