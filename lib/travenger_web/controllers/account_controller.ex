defmodule TravengerWeb.AccountController do
  @moduledoc """
  Account Controller
  """

  use TravengerWeb, :controller

  import Travenger.Helpers.Utils
  import Travenger.Account.Token

  alias Travenger.Account

  plug(Ueberauth)

  defp build_auth_params(auth) do
    Map.new()
    |> Map.put(:email, auth.info.email)
    |> Map.put(:image_url, auth.info.image)
    |> Map.put(:name, auth.info.name)
    |> Map.put(:first_name, auth.info.first_name)
    |> Map.put(:last_name, auth.info.last_name)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    params =
      params
      |> string_keys_to_atom()
      |> Map.merge(build_auth_params(auth))

    authenticate_or_register(conn, params)
  end

  def authenticate_or_register(conn, params) do
    with {:ok, user} <- Account.upsert_user(params),
         {:ok, token} <- generate_auth_token(user) do
      conn
      |> render("token.json", token: token)
    end
  end
end
