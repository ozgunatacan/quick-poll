defmodule QuickPoll.PollsTest do
  use QuickPoll.DataCase
  import QuickPoll.Factory

  alias QuickPoll.Polls

  describe "polls" do
    @valid_attrs %{question: "question", multi: false, duplicate_check: 1, spam_prevention: false}

    test "new_poll/0 returns a new blank changeset" do
      changeset = Polls.new_poll()
      assert changeset.__struct__ == Ecto.Changeset
    end

    test "list_polls/0 return all polls" do
      poll1 = insert!(:poll_with_option)
      poll2 = insert!(:poll_with_option)

      assert Polls.list_polls() == [poll1, poll2]
    end
  end
end
