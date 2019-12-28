defmodule QuickPollWeb.PollControllerTest do
  use QuickPollWeb.ConnCase
  import QuickPoll.Factory

  @valid_attrs nested_form_params()

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
    poll = insert_poll_with_options()
    [op1, op2] = poll.options
    conn = get(conn, Routes.poll_path(conn, :show, poll.id))

    assert html_response(conn, 200) =~ poll.question
    assert html_response(conn, 200) =~ op1.title
    assert html_response(conn, 200) =~ op2.title
  end

  test "vote with no vote params", %{conn: conn} do
    poll = insert_poll_with_options()
    [_op1, _op2] = poll.options

    attrs = %{}
    conn = post(conn, Routes.poll_path(conn, :vote, poll.id), attrs)

    assert redirected_to(conn) =~ Routes.poll_path(conn, :show, poll.id)
    assert get_flash(conn, :error) == "Please choose an option."
  end

  test "vote a valid poll and option", %{conn: conn} do
    poll = insert_poll_with_options()
    [op1, _op2] = poll.options

    attrs = %{"vote" => %{option_id: op1.id}}
    conn = post(conn, Routes.poll_path(conn, :vote, poll.id), attrs)

    assert redirected_to(conn) =~ Routes.poll_path(conn, :results, poll.id)
    assert get_flash(conn, :info) == "Thanks for voting."
  end

  test "vote with invalid poll and valid option", %{conn: conn} do
    poll = insert_poll_with_options()
    [_op1, op2] = poll.options

    attrs = %{"vote" => %{option_id: op2.id}}

    assert_error_sent 404, fn ->
      post(conn, Routes.poll_path(conn, :vote, 12_314), attrs)
    end
  end

  test "vote with valid poll and invalid option", %{conn: conn} do
    poll = insert_poll_with_options()
    [_op1, _op2] = poll.options

    attrs = %{"vote" => %{option_id: "122345"}}
    conn = post(conn, Routes.poll_path(conn, :vote, poll.id), attrs)

    assert redirected_to(conn) =~ Routes.poll_path(conn, :show, poll.id)
    assert get_flash(conn, :error) == "Something went wrong."
  end

  test "show results of the poll", %{conn: conn} do
    poll = insert_poll_with_options()
    [op1, op2] = poll.options

    insert_list(3, :vote, %{poll: poll, option: op1})
    insert_list(2, :vote, %{poll: poll, option: op2})

    conn = get(conn, Routes.poll_path(conn, :results, poll.id))

    assert html_response(conn, 200) =~ poll.question
    assert html_response(conn, 200) =~ "#{op1.title} Votes: #{3}"
    assert html_response(conn, 200) =~ "#{op2.title} Votes: #{2}"
  end
end
