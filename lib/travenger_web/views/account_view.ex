defmodule TravengerWeb.AccountView do
  use TravengerWeb, :view

  def render("token.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
