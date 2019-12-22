defmodule QuickPoll.Polls do
  alias QuickPoll.{Poll, Option, Repo}

  def list_polls() do
    Repo.all(Poll)
    |> Repo.preload(:options)
  end

  def new_poll() do
    Poll.changeset(%Poll{}, %{})
  end

  def create_option(attrs) do
    %Option{}
    |> Option.changeset(attrs)
    |> Repo.insert()
  end
end
