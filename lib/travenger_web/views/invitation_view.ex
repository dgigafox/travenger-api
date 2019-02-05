defmodule TravengerWeb.InvitationView do
  use TravengerWeb, :view

  alias __MODULE__

  def render("show.json", %{invitation: invitation}) do
    %{data: render_one(invitation, InvitationView, "invitation.json")}
  end

  def render("invitation.json", %{invitation: invitation}) do
    %{
      id: invitation.id,
      status: invitation.status,
      accepted_at: invitation.accepted_at
    }
  end
end
