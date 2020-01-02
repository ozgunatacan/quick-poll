defmodule QuickPollWeb.Schema.ChangesetErrors do
  def error_details(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, options} ->
      Enum.reduce(options, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
