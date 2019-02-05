defmodule TravengerWeb.Plugs.Context do
  @moduledoc """
  Plug that puts conn resource into context
  """

  @behaviour Plug

  import Travenger.Account.Guardian.Plug

  def init(opts), do: opts

  @doc """
  Get and parse the token from the `Authorization` header,
  get the corresponding resource from it, and
  assign the resource in the Plug.Conn
  """
  def call(conn, _) do
    Absinthe.Plug.put_options(conn, context: build_context(conn))
  end

  defp build_context(conn) do
    case current_resource(conn) do
      nil -> %{}
      user -> %{current_user: user}
    end
  end
end
