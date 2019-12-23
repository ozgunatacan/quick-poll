defmodule QuickPoll.Polls do
  alias QuickPoll.{Poll, Repo}

  def list_polls() do
    Repo.all(Poll)
    |> Repo.preload(:options)
  end

  def change_poll(%Poll{} = poll) do
    Poll.changeset(poll, %{})
  end

  def create_poll(attrs) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  def get_poll!(id) do
    Repo.get!(Poll, id)
    |> Repo.preload(:options)
  end
end
