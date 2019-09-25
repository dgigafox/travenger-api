defmodule TravengerWeb.EventControllerTest do
  use TravengerWeb.ConnCase

  import Travenger.Travel.Factory

  @page_fields %{"page_size" => 20, "page_number" => 1}

  describe "index/2" do
    test "returns a paginated list of events" do
      insert_list(3, :event)
      conn = build_conn()
      conn = get(conn, event_path(conn, :index), @page_fields)
      assert html_response(conn, 200)
    end
  end
end
