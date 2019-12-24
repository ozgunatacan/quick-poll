defmodule QuickPoll.Repo.Migrations.CreateVotesTable do
  use Ecto.Migration

  def change do
    create table("votes") do
      add :poll_id, references("polls", on_delete: :delete_all)
      add :option_id, references("options", on_delete: :delete_all)

      timestamps()
    end

    create index("votes", :poll_id)
  end
end
