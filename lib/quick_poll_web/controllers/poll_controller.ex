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
end
