defmodule Stackdelivery.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: true
    children = [
      supervisor(Stackdelivery.StackGen.Supervisor, []),
      supervisor(Stackdelivery.StoreGen.Supervisor, [])
    ]
    opts = [strategy: :one_for_one, name: StackDelivery.Supervisor]
    Supervisor.start_link(children, opts)
  end
end