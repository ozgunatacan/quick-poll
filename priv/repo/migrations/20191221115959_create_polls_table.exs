defmodule QuickPoll.Repo.Migrations.CreatePollsTable do
  use Ecto.Migration

  def change do
    create table("polls") do
      add :question, :string, null: false
      add :multi, :boolean, default: false
      add :duplicate_check, :integer, default: 0
      add :spam_prevention, :boolean, default: true

      timestamps()
    end
  end
end
