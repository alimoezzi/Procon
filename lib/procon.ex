defmodule Procon.Producer do
  use GenServer
  @delay 1000

  # client side
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: {:global, :producer})
  end

  # get state from our process
  def get do
    # sync
    GenServer.call({:global, :producer}, :get)
  end

  # server side /callback functions
  def init(i) do
    GenServer.cast({:global, :producer}, :produce)
    {:ok, i}
  end

  def handle_call(:get, _from, state) when length(state) > 0 do
    # {:atom, oldstate, newstate}
    [h | t] = state
    {:reply, h, t}
  end

  def handle_call(:get, _from, _state) do
    # {:atom, oldstate, newstate}
    {:reply, :none, []}
  end

  def handle_cast(:produce, state) do
    spawn(fn -> Process.sleep(@delay) && GenServer.cast({:global, :producer}, :produce) end)
    {:noreply, state ++ Enum.to_list(50..(2 * 50 + 1))}
  end
end
