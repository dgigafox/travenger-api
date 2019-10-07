defmodule TravengerWeb.EventController do
  use TravengerWeb, :controller

  alias Travenger.Travel

  def index(conn, params) do
    events = Travel.list_events(params)
    render(conn, "index.html", events: events)
  end
end
