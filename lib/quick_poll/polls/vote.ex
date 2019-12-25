defmodule QuickPoll.Vote do
  use Ecto.Schema

  import Ecto.Changeset
  alias QuickPoll.{Poll, Option, Vote, Repo}

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
    |> validate_option
    |> foreign_key_constraint(:poll_id)
    |> foreign_key_constraint(:option_id)
  end

  def validate_option(changeset) do
    case changeset.valid? do
      true ->
        option_id = get_field(changeset, :option_id)

        with poll <- Repo.get!(Poll, get_field(changeset, :poll_id)) |> Repo.preload(:options),
             true <- Enum.any?(poll.options, fn o -> o.id == option_id end) do
          changeset
        else
          _ -> add_error(changeset, :option_id, "Vote is not valid")
        end

      _ ->
        changeset
    end
  end
end
