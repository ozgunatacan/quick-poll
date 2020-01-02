defmodule QuickPollWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use QuickPollWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: QuickPollWeb.Schema.Schema

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(QuickPollWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)
        {:ok, socket: socket}
      end
    end
  end
end
