defmodule QuickPollWeb.PollController do
  use QuickPollWeb, :controller

  alias QuickPoll.{Poll, Option, Polls}

  def new(conn, _params) do
    poll = Polls.change_poll(%Poll{options: [%Option{}, %Option{}]})
    render(conn, "new.html", poll: poll)
  end
end
