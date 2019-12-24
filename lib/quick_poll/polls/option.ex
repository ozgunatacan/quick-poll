defmodule QuickPoll.Option do
  use Ecto.Schema
  import Ecto.Changeset

  alias QuickPoll.{Option, Poll}
  @timestamps_opts [type: :utc_datetime]

  schema "options" do
    field :title, :string
    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(%Option{} = option, attrs) do
    option
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> validate_length(:title, max: 200)
  end
end
