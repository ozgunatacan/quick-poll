defmodule QuickPollWeb.Schema.Subscription.NewVoteTest do
  use QuickPollWeb.SubscriptionCase

  import QuickPoll.Factory

  test "should receive results when new vote is received", %{socket: socket} do
    poll = insert_poll_with_options()
    [op1, _op2] = poll.options

    subscription = """
    subscription{
      newVote(pollId:#{poll.id}){
        optionId
        count
      }
    }
    """

    mutation = """
    mutation($pollId: ID!, $optionId: ID!) {
      vote(pollId: $pollId, optionId: $optionId) {
        optionId
        pollId
      }
    }
    """

    ref = push_doc(socket, subscription)
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    variables = %{"pollId" => poll.id, "optionId" => op1.id}
    ref = push_doc(socket, mutation, variables: variables)

    assert_reply ref, :ok, reply

    expected = %{
      result: %{
        data: %{
          "newVote" => [
            %{
              "count" => 1,
              "optionId" => Integer.to_string(op1.id)
            }
          ]
        }
      },
      subscriptionId: subscription_id
    }

    assert_push "subscription:data", push
    assert expected == push
  end
end
