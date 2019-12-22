defmodule QuickPollWeb.PollController do
  use QuickPollWeb, :controller

  alias QuickPoll.Polls

  def new(conn, _params) do
    changeset = Polls.new_poll()
    render(conn, "new.html", changeset: changeset)
  end
end
