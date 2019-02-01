defmodule TravengerWeb.JoinRequestView do
  use TravengerWeb, :view

  alias __MODULE__

  def render("show.json", %{join_request: joinreq}) do
    %{data: render_one(joinreq, JoinRequestView, "joinreq.json")}
  end

  def render("joinreq.json", %{join_request: joinreq}) do
    %{
      id: joinreq.id,
      status: joinreq.status
    }
  end
end
