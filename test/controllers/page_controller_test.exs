defmodule Portal.PageControllerTest do
  use Portal.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302)
  end
end