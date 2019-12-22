defmodule QuickPoll.Repo.Migrations.CreateOptionsTable do
  use Ecto.Migration

  def change do
    create table("options") do
      add :title, :string, null: false
      add :poll_id, references("polls"), on_delete: :delete_all
      add :votes, :integer, default: 0

      timestamps()
    end

    create index("options", :poll_id)
  end
end
