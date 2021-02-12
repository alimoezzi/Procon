defmodule Procon.Producer do
  use GenServer
  # client side
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: {:global, :producer})
  end
  # server side /callback functions
  def init(i) do
    GenServer.cast({:global, :producer}, :produce)
    {:ok, i}
  end
end
