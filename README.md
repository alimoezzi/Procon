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
