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

  def changeset(%Vote{} = vote, attrs, poll) do
    valid_options = Enum.map(poll.options, & &1.id)

    vote
    |> cast(attrs, [:option_id])
    |> put_change(:poll_id, poll.id)
    |> validate_required([:poll_id, :option_id])
    |> validate_options(valid_options)
    |> foreign_key_constraint(:poll_id)
    |> foreign_key_constraint(:option_id)
  end

  def validate_options(changeset, valid_options) do
    case changeset.valid? do
      true ->
        option_id = get_field(changeset, :option_id)

        case Enum.member?(valid_options, option_id) do
          true -> changeset
          _ -> add_error(changeset, :option_id, "Vote is not valid")
        end

      _ ->
        changeset
    end
  end
end
