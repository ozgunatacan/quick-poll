defmodule QuickPollWeb.Schema.Schema do
  use Absinthe.Schema

  alias QuickPollWeb.Resolvers.Polls

  query do
    @desc "Gets the details of a poll by id"
    field :poll, :poll do
      arg(:id, non_null(:id))
      resolve(&Polls.poll/3)
    end
  end

  # Object types
  object :poll do
    field :id, non_null(:id)
    field :question, non_null(:string)
    field :multi, non_null(:boolean)
    field :duplicate_check, non_null(:integer)
    field :spam_prevention, non_null(:boolean)
    field :options, non_null(list_of(:option))
  end

  object :option do
    field :id, non_null(:id)
    field :title, non_null(:string)
  end
end
