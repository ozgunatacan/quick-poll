defmodule QuickPollWeb.Schema.SchemaTest do
  use QuickPollWeb.ConnCase

  import QuickPoll.Factory

  describe "queries" do
    test "poll field return poll with given id", %{conn: conn} do
      poll = insert_poll_with_options()
      [op1, op2] = poll.options

      query = """
      {
        poll(id: #{poll.id}) {
          id
          question
          multi
          spamPrevention
          duplicateCheck
          options {
            id
            title
          } 
        }
      }
      """

      conn = get(conn, "/api", query: query)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "poll" => %{
                   "id" => Integer.to_string(poll.id),
                   "question" => poll.question,
                   "multi" => poll.multi,
                   "spamPrevention" => poll.spam_prevention,
                   "duplicateCheck" => poll.duplicate_check,
                   "options" => [
                     %{
                       "id" => Integer.to_string(op1.id),
                       "title" => op1.title
                     },
                     %{
                       "id" => Integer.to_string(op2.id),
                       "title" => op2.title
                     }
                   ]
                 }
               }
             }
    end

    test "results field should return results of the given poll id", %{conn: conn} do
      poll = insert_poll_with_options()
      [op1, op2] = Enum.sort(poll.options, &(&1.id < &2.id))
      insert_list(4, :vote, poll: poll, option: op1)
      insert_list(6, :vote, poll: poll, option: op2)

      query = """
      {
        results(id: #{poll.id}) {
          optionId
          count
        }
      }
      """

      conn = get(conn, "/api", query: query)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "results" => [
                   %{
                     "optionId" => Integer.to_string(op1.id),
                     "count" => 4
                   },
                   %{
                     "optionId" => Integer.to_string(op2.id),
                     "count" => 6
                   }
                 ]
               }
             }
    end
  end

  describe "mutations" do
    test "createPoll mutation creates a new poll", %{conn: conn} do
      mutation = """
      mutation($poll: PollInput!){
        createPoll(input: $poll) {
          question
          options {
            title
          }
        }
      }
      """

      [op1, op2] = build_pair(:option)
      poll_input = string_params_for(:poll, options: [op1, op2])

      conn = post(conn, "/api", query: mutation, variables: %{"poll" => poll_input})

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createPoll" => %{
                   "question" => poll_input["question"],
                   "options" => [
                     %{"title" => op1.title},
                     %{"title" => op2.title}
                   ]
                 }
               }
             }
    end

    test "vote mutation votes successfully for a given poll", %{conn: conn} do
      poll = insert_poll_with_options()
      [op1, _op2] = poll.options

      mutation = """
      mutation($pollId: ID!, $optionId: ID!) {
        vote(pollId: $pollId, optionId: $optionId) {
          optionId
          pollId
        }
      }
      """

      variables = %{"pollId" => poll.id, "optionId" => op1.id}
      conn = post(conn, "/api", query: mutation, variables: variables)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "vote" => %{
                   "optionId" => Integer.to_string(op1.id),
                   "pollId" => Integer.to_string(poll.id)
                 }
               }
             }
    end
  end
end
