defmodule Stackdelivery.Stack do
  use GenServer
  require Logger

  def init(args) do
    Logger.info fn -> {"Starting a New GenServer Stack with args #{args}", [metadata: args]} end 
    {:ok, []}
  end

  def start_link(stack_name, opts \\ []) do
    # IO.inspect state, label: "starting with inputs"
    Logger.info fn-> {"starting with state: #{stack_name} | opts: #{opts}", [metadata: {stack_name, opts}]} end
    {name, opts} = Keyword.pop(opts, :name, stack_name || "stack_#{Time.utc_now |> Time.to_string}")
    GenServer.start_link(__MODULE__, [], opts ++ [name: via_tuple(name)])
  end

  def pop(name), do: GenServer.call(via_tuple(name), :pop)

  def push(name, item), do: GenServer.cast(via_tuple(name), {:push, item})

  def peek(name), do: GenServer.call(via_tuple(name), :peek)

  def deque(name), do: GenServer.call(via_tuple(name), :deque)
  
  defp via_tuple(name), do: {:via, :gproc, {:n, :l, {:stack, name}}}

  @doc """
  pop from front of queue
  """
  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_call(:pop, _from, []), do: {:reply, nil, []}

  @doc """
  peek the front of queue
  """
  def handle_call(:peek, _from, [h | _t] = state), do: {:reply, h, state}
  def handle_call(:peek, _from, [] = state), do: {:reply, nil, state}

  @doc """
  pop from the tail of queue
  """
  def handle_call(:deque, _from, []), do: {:reply, nil, []}
  def handle_call(:deque, _from, state) do
    {new_state, last_pop_item} = pop_last(state)
    {:reply, last_pop_item, new_state}
  end

  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}

  defp pop_last(state) when is_list(state) do
    {new_state, last_pop_item} = Enum.split(state, -1)
    {new_state, Enum.fetch!(last_pop_item, 0)}
  end

end