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
      [op1, op2] = poll.options
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
end
