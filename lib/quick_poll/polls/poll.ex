defmodule QuickPoll.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  alias QuickPoll.{Poll, Option}

  @timestamps_opts [type: :utc_datetime]

  schema "polls" do
    field :question, :string
    field :multi, :boolean, default: false
    field :duplicate_check, :integer, default: 0
    field :spam_prevention, :boolean, default: true

    has_many :options, Option
    timestamps()
  end

  def changeset(%Poll{} = poll, attrs) do
    poll
    |> cast(attrs, [:question, :multi, :duplicate_check, :spam_prevention])
    |> cast_assoc(:options, required: true)
    |> validate_required([:question])
    |> validate_length(:question, max: 200)
  end
end
