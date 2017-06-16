defmodule Stackdelivery.StoreGen.Supervisor do
  @moduledoc """
  Supervisor for StackGen module
  """

  use Supervisor
  alias Stackdelivery.Store

  @name :store_sup

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(args) do
    IO.inspect __MODULE__, label: "starting..module is"
    IO.inspect args, label: "initial args are"
    children = [
      worker(Store, [])
    ]
    opts = [strategy: :one_for_one, name: StoreGenSup]
    supervise(children, opts)
  end
end