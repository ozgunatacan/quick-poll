defmodule QuickPoll.Vote do
  use Ecto.Schema

  import Ecto.Changeset
  alias QuickPoll.{Poll, Option, Vote}

  @timestamps_opts [type: :utc_datetime]

  schema "votes" do
    belongs_to :poll, Poll
    belongs_to :option, Option

    timestamps()
  end

  def changeset(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, [:poll_id, :option_id])
    |> validate_required([:poll_id, :option_id])
    |> foreign_key_constraint(:poll_id)
    |> foreign_key_constraint(:option_id)
  end
end
