defmodule QuickPoll.Factory do
  use ExMachina.Ecto, repo: QuickPoll.Repo
  alias QuickPoll.{Poll, Option, Vote, Repo}

  def poll_factory() do
    %Poll{
      question: sequence(:question, &"Question-#{&1}")
    }
  end

  def option_factory() do
    %Option{
      title: sequence(:title, &"Title-#{&1}")
    }
  end

  def vote_factory() do
    %Vote{
      poll: build(:poll),
      option: build(:option)
    }
  end

  def insert_poll_with_options() do
    poll = insert(:poll)
    insert_pair(:option, %{poll: poll})

    poll
    |> Repo.preload(:options)
  end

  # needed this because we do nested forms
  def nested_form_params(_attrs \\ %{}) do
    params_for(:poll)
    |> Map.merge(%{
      options: %{
        rand_form_id() => params_for(:option),
        rand_form_id() => params_for(:option)
      }
    })
  end

  defp rand_form_id() do
    Integer.to_string(Enum.random(1..1000))
  end
end
