defmodule QuickPollWeb.PollControllerTest do
  use QuickPollWeb.ConnCase

  test "GET /polls/new", %{conn: conn} do
    conn = get(conn, "/polls/new")
    assert html_response(conn, 200) =~ "New Poll"
    assert html_response(conn, 200) =~ "Type your question here"
    assert html_response(conn, 200) =~ "Enter poll option"
  end
end
