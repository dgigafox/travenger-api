defmodule TravengerWeb.Plugs.GraphqlAuth do
  @moduledoc """
  Plug that puts conn resource into context
  """

  @behaviour Plug

  import Plug.Conn
  import Travenger.Account.Guardian.Plug

  def init(opts), do: opts

  @doc """
  Get and parse the token from the `Authorization` header,
  get the corresponding resource from it, and
  assign the resource in the Plug.Conn
  """
  def call(conn, _) do
    case current_resource(conn) do
      nil -> conn
      resource -> put_private(conn, :absinthe, %{context: %{user: resource}})
    end
  end
end
