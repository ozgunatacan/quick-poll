defmodule QuickPoll.Polls do
  alias QuickPoll.{Poll, Repo, Vote}
  import Ecto.Query

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

  def vote(%Poll{} = poll, attrs) do
    %Vote{}
    |> Vote.changeset(attrs, poll)
    |> Repo.insert()
  end

  def results(poll_id) do
    q =
      from v in Vote,
        where: v.poll_id == ^poll_id,
        group_by: v.option_id,
        select: {v.option_id, count(v.id)}

    Map.new(Repo.all(q))
  end
end
