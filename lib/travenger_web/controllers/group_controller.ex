defmodule TravengerWeb.GroupController do
  use TravengerWeb, :controller

  import Travenger.Account.Guardian.Plug
  import Travenger.Helpers.Utils

  alias Travenger.Account
  alias Travenger.Community

  alias TravengerWeb.InvitationView

  @require_admin_functions ~w(invite)a

  plug(
    TravengerWeb.Plugs.RequireGroupAdmin
    when action in @require_admin_functions
  )

  def create(conn, params) do
    with user <- current_resource(conn),
         {:ok, member} <- Community.build_member_from_user(user),
         {:ok, group} <- Community.create_group(member, params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{group: group})
    end
  end

  def invite(conn, params) do
    with params <- string_keys_to_atom(params),
         {:ok, user} <- get_user(params.user_id),
         {:ok, group} <- get_group(params.group_id),
         {:ok, member} <- Community.build_member_from_user(user),
         {:ok, invitation} <- Community.invite(member, group) do
      conn
      |> put_status(:created)
      |> put_view(InvitationView)
      |> render("show.json", %{invitation: invitation})
    end
  end

  defp get_user(user_id) do
    case Account.get_user(user_id) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  defp get_group(group_id) do
    case Community.get_group(group_id) do
      nil -> {:error, "group not found"}
      group -> {:ok, group}
    end
  end
end
