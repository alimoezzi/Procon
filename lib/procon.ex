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
  def handle_cast(:produce, state) do
    spawn(fn -> Process.sleep(@delay) && GenServer.cast({:global, :producer}, :produce) end)
    {:noreply, state ++ Enum.to_list(50..(2 * 50 + 1))}
  end
end
