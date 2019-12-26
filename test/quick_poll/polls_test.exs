defmodule QuickPoll.PollsTest do
  use QuickPoll.DataCase
  import QuickPoll.Factory

  alias QuickPoll.{Polls, Poll}

  describe "polls" do
    @valid_attrs nested_form_params()

    test "change_poll/0 returns a new blank changeset" do
      changeset = Polls.change_poll(%Poll{})
      assert changeset.__struct__ == Ecto.Changeset
    end

    test "create_poll with options" do
      {:ok, poll} = Polls.create_poll(@valid_attrs)
      assert poll.question == @valid_attrs.question
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

      {:error, changeset} =
        Polls.create_poll(
          Map.merge(@valid_attrs, %{options: [%{title: String.duplicate("a", 201)}]})
        )

      assert %{options: [%{title: ["should be at most 200 character(s)"]}]} ==
               errors_on(changeset)
    end

    test "create a poll with too long question" do
      {:error, changeset} =
        Polls.create_poll(Map.merge(@valid_attrs, %{question: String.duplicate("q", 201)}))

      assert %{question: ["should be at most 200 character(s)"]} == errors_on(changeset)
    end

    test "list_polls/0 return all polls" do
      poll1 = insert_poll_with_options()
      poll2 = insert_poll_with_options()
      assert Polls.list_polls() == [poll1, poll2]
    end

    test "vote existing poll and option" do
      poll1 = insert_poll_with_options()
      poll1 = Polls.get_poll!(poll1.id)
      [option1, option2] = poll1.options

      {:ok, _vote} = Polls.vote(poll1, %{poll_id: poll1.id, option_id: option1.id})
      assert Polls.results(poll1.id) == %{option1.id => 1}

      {:ok, _vote} = Polls.vote(poll1, %{poll_id: poll1.id, option_id: option2.id})
      assert Polls.results(poll1.id) == %{option1.id => 1, option2.id => 1}

      {:ok, _vote} = Polls.vote(poll1, %{poll_id: poll1.id, option_id: option1.id})
      assert Polls.results(poll1.id) == %{option1.id => 2, option2.id => 1}
    end

    test "vote an existing poll with options from other poll" do
      poll1 = insert_poll_with_options()
      poll1 = Polls.get_poll!(poll1.id)
      [option11, _option12] = poll1.options

      poll2 = insert_poll_with_options()
      poll2 = Polls.get_poll!(poll2.id)
      [option21, _option22] = poll2.options

      {:error, changeset} = Polls.vote(poll1, %{poll_id: poll1.id, option_id: option21.id})
      assert %{option_id: ["Vote is not valid"]} == errors_on(changeset)

      {:ok, _vote} = Polls.vote(poll1, %{poll_id: poll1.id, option_id: option11.id})
      assert Polls.results(poll1.id) == %{option11.id => 1}
    end
  end
end
