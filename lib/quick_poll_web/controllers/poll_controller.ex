defmodule QuickPollWeb.PollController do
  use QuickPollWeb, :controller

  alias QuickPoll.{Poll, Option, Polls}

  def new(conn, _params) do
    poll = Polls.change_poll(%Poll{options: [%Option{}, %Option{}]})
    render(conn, "new.html", poll: poll)
  end

  def create(conn, %{"poll" => poll_params}) do
    case Polls.create_poll(poll_params) do
      {:ok, poll} ->
        conn
        |> put_flash(:info, "Poll created successfully.")
        |> redirect(to: Routes.poll_path(conn, :show, poll))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", poll: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    poll = Polls.get_poll!(id)
    render(conn, "show.html", poll: poll)
  end

  def vote(conn, %{"id" => id, "vote" => vote_params}) do
    with poll <- Polls.get_poll!(id),
         {:ok, _vote} <- Polls.vote(poll, vote_params) do
      conn
      |> put_flash(:info, "Thanks for voting.")
      |> redirect(to: Routes.poll_path(conn, :results, id))
    else
      _ ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> redirect(to: Routes.poll_path(conn, :show, id))
    end
  end

  def vote(conn, %{"id" => id}) do
    _poll = Polls.get_poll!(id)

    conn
    |> put_flash(:error, "Please choose an option.")
    |> redirect(to: Routes.poll_path(conn, :show, id))
  end

  def results(conn, %{"id" => id}) do
    poll = Polls.get_poll!(id)
    results = Polls.results(poll.id)
    render(conn, "results.html", poll: poll, results: results)
  end
end
