defmodule TravengerWeb.GroupController do
  use TravengerWeb, :controller

  import Travenger.Account.Guardian.Plug

  alias Travenger.TravelGroup

  def create(conn, params) do
    with user <- current_resource(conn),
         {:ok, member} <- TravelGroup.build_member_from_user(user),
         {:ok, group} <- TravelGroup.create_group(member, params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{group: group})
    end
  end
end
