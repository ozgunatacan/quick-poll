defmodule QuickPollWeb.PollView do
  use QuickPollWeb, :view

  alias QuickPoll.{Poll, Polls, Option}

  def link_to_option_fields do
    changeset = Polls.change_poll(%Poll{options: [%Option{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "option_fields.html", f: form)
    link("Add Option", to: "#", "data-template": fields, id: "add_option")
  end
end
