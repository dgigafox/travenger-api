defmodule TravengerWeb.GroupController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils
  import Travenger.Account.Guardian.Plug

  alias Travenger.TravelGroup

  def create(conn, params) do
    user = current_resource(conn)

    params =
      params
      |> string_keys_to_atom()
      |> Map.put(:creator_id, user.id)

    with {:ok, group} <- TravelGroup.create_group(params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{group: group})
    end
  end
end
