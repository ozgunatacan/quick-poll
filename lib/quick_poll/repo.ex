defmodule QuickPoll.Repo do
  use Ecto.Repo,
    otp_app: :quick_poll,
    adapter: Ecto.Adapters.Postgres
end
