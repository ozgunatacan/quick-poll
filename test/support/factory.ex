defmodule QuickPoll.Factory do
  alias QuickPoll.{Repo, Poll, Option}

  def build(:poll) do
    %Poll{question: "my question"}
  end

  def build(:option) do
    %Option{title: "Option 1"}
  end

  def build(:poll_with_option) do
    %Poll{
      question: "Poll with options",
      options: [
        build(:option, title: "option 1"),
        build(:option, title: "option 2")
      ]
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end
end
