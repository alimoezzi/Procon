# Procon

This is Producer-Consumer problem solution in `elixir` .

It is design so that it support distributed nodes through `erlang`  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `procon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:procon, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/procon](https://hexdocs.pm/procon).

# How to run

> iex --sname bar -S mix # in one terminal

> iex --sname foo -S mix # in another terminal

> Node.connect(:"bar@COMPUTER") # :global.whereis_name :producer

> Procon.Consumer.start # in foo node

> Procon.Consumer.start # in bar node

Note: The Producer is automatically commenced and registered globally

# Implementation

It is consisted of 2 module:

## 1. `Procon.Producer`

   The producer module is implemented using `GenServer`.

   It is registered by default so that supervisor starts it at startup

   ```elixir
   defmodule Procon.Application do
     # See https://hexdocs.pm/elixir/Application.html
     # for more information on OTP Applications
     @moduledoc false
   
     use Application
   
     @impl true
     def start(_type, _args) do
       children = [
         # Starts a worker by calling: Procon.Worker.start_link(arg)
         # {Procon.Worker, arg}
         {Procon.Producer, []},
       ]
   
       # See https://hexdocs.pm/elixir/Supervisor.html
       # for other strategies and supported options
       opts = [strategy: :one_for_one, name: Procon.Supervisor]
       Supervisor.start_link(children, opts)
     end
   end
   
   ```

   Then on the `start_link`  function of it, it is registered globally through `:producer` name.

   The Producer module requests itself periodically to produce integers. The first call is located in init function

   ```elixir
     # server side /callback functions
     def init(i) do
       GenServer.cast({:global, :producer}, :produce)
       {:ok, i}
     end
   ```

   For producing item is handled asynchronously using `cast` implementation

   ```elixir
   def handle_cast(:produce, state) do
       spawn(fn -> Process.sleep(@delay) && GenServer.cast({:global, :producer}, :produce) end)
       {:noreply, state ++ Enum.to_list(50..(2 * 50 + 1))}
     end
   ```

   Here a process is spawned each time to recall the `:produce` cast. After that the state of the server is updated by concatenating the new list to old state.

   The client interacts with server using `:get` . If the state contains elements head of the list is detached and returned to client. For the sake of error handling a different version of `:get:` handle call is included which yields `:none` if the state is empty

   ```elixir
   def handle_call(:get, _from, state) when length(state) > 0 do
       # {:atom, oldstate, newstate}
       [h | t] = state
       {:reply, h, t}
     end
   
     def handle_call(:get, _from, _state) do
       # {:atom, oldstate, newstate}
       {:reply, :none, []}
     end
   ```

   

## 2. `Procon.Consumer`

The Consumer is rather simple it consists of a single `loop` function which is spawned and requests a new item every seconds

```elixir
defmodule Procon.Consumer do
  def start do
    spawn(loop())
  end

  def loop do
    IO.puts("Consumer #{inspect(self())} consumes #{Procon.Producer.get()}")
    Process.sleep(1000)
    loop()
  end
end
```

