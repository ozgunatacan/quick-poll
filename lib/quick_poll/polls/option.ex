defmodule QuickPoll.Option do
  use Ecto.Schema
  import Ecto.Changeset

  alias QuickPoll.{Option, Poll}
  @timestamps_opts [type: :utc_datetime]

  schema "options" do
    field :title, :string
    field :votes, :integer, default: 0
    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(%Option{} = option, attrs) do
    option
    |> cast(attrs, [:title, :votes])
    |> validate_required([:title])
  end
end
