defmodule Stackdelivery.Store do
  use GenServer
  require Logger

  def init(state) do
    Logger.info fn -> {"Starting a New GenServer Stack with args #{state}", [metadata: state]} end
    table = :ets.new(:db, [:named_table, read_concurrency: true])
    Process.flag(:trap_exit, true)
    {:ok, table}
  end

  def terminate(reason, table) do
    Logger.info fn-> {reason} end
    IO.inspect table
    :ets.delete table
    Logger.info "Deleted ets table"
  end

  def start_link do
    Logger.info fn-> "starting ets Genserver" end
    GenServer.start_link(__MODULE__, [], [name: :db])
  end

  def fetch(key), do: GenServer.call(:db, {:fetch, key})

  def pop(key), do: GenServer.call(:db, {:pop, key})

  def push([{key, val}]), do: GenServer.cast(:db, {:push, [{key, val}]})

  def peek, do: GenServer.call(:db, :peek)

  def handle_call({:fetch, key}, _from, table) do
    res = with [{key, val}] <- :ets.lookup(table, key),
    do: [{key, val}],
    else: (_other -> :invalid_key)
    {:reply, res, table}
  end

  @doc """
  delete the key item from table and return it
  returns either a tuple or :invalid_key
  """
  def handle_call({:pop, key}, _from, table) do
    res = with [{key, val}] <- :ets.lookup(table, key),
    do: (
      :ets.delete(table, key)
      [{key, val}]
    ),
    else: (_other -> :invalid_key)
    {:reply, res, table}
  end
  
  @doc """
  peek the front of queue
  """
  def handle_call(:peek, _from, table) do
    res = case :ets.first(table) do
      :"$end_of_table" -> nil
      key -> key
    end
    {:reply, res, table}
  end

  def handle_cast({:push, [{key, val}] = _tuple}, table) do
    :ets.insert(table, [{key, val}])
    {:noreply, table}
  end

end