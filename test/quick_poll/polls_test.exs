defmodule QuickPoll.PollsTest do
  use QuickPoll.DataCase
  import QuickPoll.Factory

  alias QuickPoll.{Polls, Poll}

  describe "polls" do
    @valid_attrs %{
      question: "question",
      multi: false,
      duplicate_check: 1,
      spam_prevention: false,
      options: %{"1" => %{title: "op 1"}, "23412341" => %{title: "op 2"}}
    }

    test "change_poll/0 returns a new blank changeset" do
      changeset = Polls.change_poll(%Poll{})
      assert changeset.__struct__ == Ecto.Changeset
    end

    test "create_poll with options" do
      {:ok, poll} = Polls.create_poll(@valid_attrs)
      assert poll.question == "question"
      assert Enum.count(poll.options) == 2
    end

    test "creating poll without options" do
      {:error, changeset} = Polls.create_poll(Map.delete(@valid_attrs, :options))
      assert %{options: ["can't be blank"]} == errors_on(changeset)
    end

    test "creating a poll with invalid options" do
      {:error, _changeset} = Polls.create_poll(Map.merge(@valid_attrs, %{options: []}))

      {:error, changeset} =
        Polls.create_poll(Map.merge(@valid_attrs, %{options: [%{not_valid: "test"}]}))

      assert %{options: [%{title: ["can't be blank"]}]} == errors_on(changeset)
    end

    test "list_polls/0 return all polls" do
      poll1 = insert!(:poll_with_option)
      poll2 = insert!(:poll_with_option)

      assert Polls.list_polls() == [poll1, poll2]
    end
  end
end
