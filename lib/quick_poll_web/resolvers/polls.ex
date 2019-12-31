defmodule QuickPollWeb.Resolvers.Polls do
  alias QuickPoll.Polls

  def poll(_parent, %{id: id}, _context) do
    {:ok, Polls.get_poll!(id)}
  end
end
