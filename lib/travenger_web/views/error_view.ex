defmodule TravengerWeb.ErrorView do
  use TravengerWeb, :view

  @not_found %{
    status: "404",
    title: "Resource not found"
  }

  @forbidden %{
    status: "403",
    title: "Forbidden"
  }

  # JSON errors

  def render("404.json", _assigns) do
    %{errors: [@not_found]}
  end

  def render("403.json", _assigns) do
    %{errors: [@forbidden]}
  end

  # HTML errors

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  # def template_not_found(template, _assigns) do
  #   Controller.status_message_from_template(template)
  # end
end
