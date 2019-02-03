defmodule TravengerWeb.GroupController do
  use TravengerWeb, :controller

  import Travenger.Account.Guardian.Plug
  import Travenger.Helpers.Utils

  alias Travenger.Account
  alias Travenger.Community

  alias TravengerWeb.InvitationView
  alias TravengerWeb.JoinRequestView

  @require_admin_functions ~w(invite)a

  plug(
    TravengerWeb.Plugs.RequireGroupAdmin
    when action in @require_admin_functions
  )

  def index(conn, params) do
    params = string_keys_to_atom(params)
    render(conn, "index.json", groups: Community.list_groups(params))
  end

  def show(conn, params) do
    with params <- string_keys_to_atom(params),
         {:ok, group} <- get_group(params.id) do
      render(conn, "show.json", group: group)
    end
  end

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

  def update(conn, params) do
    with params <- string_keys_to_atom(params),
         {:ok, group} <- get_group(params.id),
         {:ok, group} <- Community.update_group(group, params) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{group: group})
    end
  end

  def join(conn, params) do
    with params <- string_keys_to_atom(params),
         user <- current_resource(conn),
         {:ok, member} <- Community.build_member_from_user(user),
         {:ok, group} <- get_group(params.group_id),
         {:ok, joinreq} <- Community.join_group(member, group) do
      conn
      |> put_status(:ok)
      |> put_view(JoinRequestView)
      |> render("show.json", %{join_request: joinreq})
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
