defmodule QuickPollWeb.ResultsChannel do
  use QuickPollWeb, :channel

  alias QuickPoll.{Polls, Poll}

  def join("results:" <> poll_id, _payload, socket) do
    case Polls.get_poll(poll_id) do
      %Poll{} = _poll ->
        :timer.send_interval(5_000, :refresh)
        {:ok, assign(socket, :poll_id, poll_id)}

      _ ->
        {:error, %{reason: "poll_not_found"}}
    end
  end

  def handle_info(:refresh, socket) do
    poll_id = socket.assigns.poll_id
    results = Polls.results(poll_id)
    push(socket, "results", results)
    {:noreply, socket}
  end
end
