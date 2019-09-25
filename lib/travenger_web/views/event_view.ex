defmodule TravengerWeb.EventView do
  use TravengerWeb, :view

  alias Travenger.Travel

  def list_events(params) do
    %{entries: entries} = Travel.list_events(params)
    entries
  end
end
