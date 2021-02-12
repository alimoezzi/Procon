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
