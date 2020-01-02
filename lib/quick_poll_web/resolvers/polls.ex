defmodule QuickPollWeb.Resolvers.Polls do
  alias QuickPoll.{Polls, Poll}
  alias QuickPollWeb.Schema.ChangesetErrors

  def poll(_parent, %{id: id}, _context) do
    case Polls.get_poll(id) do
      %Poll{} = poll -> {:ok, poll}
      _ -> {:error, "No poll with given id"}
    end
  end

  def results(_parent, %{id: id}, _context) do
    with %Poll{} = poll <- Polls.get_poll(id),
         results <- Polls.results(poll.id) do
      results =
        results
        |> Map.keys()
        |> Enum.map(&%{option_id: &1, count: results[&1]})

      {:ok, results}
    else
      _ ->
        {:error, "No poll with given id"}
    end
  end

  def create_poll(_parent, %{input: params}, _) do
    case QuickPoll.Polls.create_poll(params) do
      {:error, changeset} ->
        {:error,
         message: "Could not create poll!", details: ChangesetErrors.error_details(changeset)}

      {:ok, poll} ->
        {:ok, poll}
    end
  end
end
