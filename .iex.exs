alias QuickPoll.{Repo, Vote, Option, Poll, Polls}
import Ecto.Query

poll = %Poll{question: "question", options: [%Option{title: "op1"}, %Option{title: "op2"}]}
