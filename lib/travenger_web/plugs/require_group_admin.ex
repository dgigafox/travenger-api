defmodule TravengerWeb.Plugs.RequireGroupAdmin do
  @moduledoc """
  Plug for checking if the current user is authorized to access the group.
  If no options are passed, the default roles to be checked are admin and creator.
  """

  @behaviour Plug

  import Plug.Conn
  import Travenger.Account.Guardian.Plug
  import Travenger.Helpers.Utils

  alias Phoenix.Controller
  alias Travenger.Community
  alias TravengerWeb.ErrorView

  @forbidden "403.json"

  def init(opts), do: opts

  def call(conn, _) do
    user = current_resource(conn)

    conn.params
    |> string_keys_to_atom()
    |> Map.put(:user_id, user.id)
    |> Map.put(:role, :admin)
    |> Community.find_membership()
    |> pass_conn(conn)
  end

  defp pass_conn(nil, conn) do
    conn
    |> put_status(403)
    |> Controller.render(ErrorView, @forbidden)
    |> halt()
  end

  defp pass_conn(_, conn), do: conn
end
