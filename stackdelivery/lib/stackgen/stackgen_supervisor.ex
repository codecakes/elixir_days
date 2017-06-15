defmodule Stackdelivery.StackGen.Supervisor do
  @moduledoc """
  Supervisor for StackGen module
  """

  use Supervisor
  alias Stackdelivery.Stack

  @name :stack_sup

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(args) do
    IO.inspect __MODULE__, label: "starting..module is"
    IO.inspect args, label: "initial args are"
    children = [
      worker(Stack, [])
    ]
    opts = [strategy: :simple_one_for_one]
    supervise(children, opts)
  end

  def shoot(name), do: Supervisor.start_child(@name, [name])

end