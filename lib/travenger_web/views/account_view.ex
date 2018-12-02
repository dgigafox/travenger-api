defmodule TravengerWeb.AccountView do
  use TravengerWeb, :view

  alias __MODULE__
  alias Scrivener.Page

  def render("token.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
