defmodule QuickPollWeb.PollControllerTest do
  use QuickPollWeb.ConnCase
  import QuickPoll.Factory

  @valid_attrs %{
    question: "question",
    multi: false,
    duplicate_check: 1,
    spam_prevention: false,
    options: %{"1" => %{title: "op 1"}, "23412341" => %{title: "op 2"}}
  }

  test "show new poll form", %{conn: conn} do
    conn = get(conn, "/polls/new")
    assert html_response(conn, 200) =~ "New Poll"
    assert html_response(conn, 200) =~ "Type your question here"
    assert html_response(conn, 200) =~ "Enter poll option"
  end

  test "Create new poll", %{conn: conn} do
    conn = post(conn, Routes.poll_path(conn, :create), poll: @valid_attrs)
    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) =~ Routes.poll_path(conn, :show, id)
  end

  test "Show poll", %{conn: conn} do
    poll = insert!(:poll_with_option)
    [op1, op2] = poll.options
    conn = get(conn, Routes.poll_path(conn, :show, poll.id))

    assert html_response(conn, 200) =~ poll.question
    assert html_response(conn, 200) =~ op1.title
    assert html_response(conn, 200) =~ op2.title
  end

  test "vote a valid poll and option", %{conn: conn} do
    poll = insert!(:poll_with_option)
    [op1, op2] = poll.options

    attrs = %{"vote" => %{poll_id: poll.id, option_id: op1.id}}
    conn = post(conn, Routes.poll_path(conn, :vote), attrs)

    assert redirected_to(conn) =~ Routes.poll_path(conn, :results, poll.id)
    assert get_flash(conn, :info) == "Thanks for voting."
  end

  test "vote with invalid poll and valid option", %{conn: conn} do
    poll = insert!(:poll_with_option)
    [_op1, op2] = poll.options

    poll_id = poll.id
    attrs = %{"vote" => %{poll_id: 12312, option_id: op2.id}}
    conn = post(conn, Routes.poll_path(conn, :vote), attrs)

    assert %{id: poll_id} = redirected_params(conn)
    assert redirected_to(conn) =~ Routes.poll_path(conn, :show, poll_id)
    assert get_flash(conn, :error) == "Something went wrong."
  end

  test "vote with valid poll and invalid option", %{conn: conn} do
    poll = insert!(:poll_with_option)
    [op1, op2] = poll.options

    poll_id = poll.id
    attrs = %{"vote" => %{poll_id: poll_id, option_id: "122345"}}
    conn = post(conn, Routes.poll_path(conn, :vote), attrs)

    assert %{id: poll_id} = redirected_params(conn)
    assert redirected_to(conn) =~ Routes.poll_path(conn, :show, poll_id)
    assert get_flash(conn, :error) == "Something went wrong."
  end
end
