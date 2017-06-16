defmodule Stackdelivery do
  @moduledoc """
  Main Stackdelivery entry point.
  This app starts a bunch of stacks as building blocks and can be joined any which way transferring ejectile between two stacks.

  The Stacks act as sources to a one or more sinks in numerous ways.

  The main operations these stacks can do are:
    - Transfer from Stack A to Stack B
    - Copy from Stack A to [Stack B, C, D, .... so on ]
    - Copy & Transfer, in which case the following concurrent operations happen:
      a. Copy from Stack A to [Stack B, C, D, .... so on ]
      b. Transfer from Stack A to only one of Stacks excluding the above stacks.
    
  Consider a Subscriber point A that has subscribed to a broadcast channel.
  When A receives the input, it can pass it down to further pipes, based on how 
  the user wants to consume this information. This way any information packet <#Package{}> can be piped like
  A |> B |> {C, D, E} |> .. or
  {A, B, C} |> {D, E, F}

  So, if there are companies like:
                                 A
                               /   \
                              B     C
                            /  \   / \
                           D   E   F  G
  
  Then A could subscribe to updates from {D, E, F, G} AND
  B could subscribe to updates from {D, E} AND
  D could subscribe to updates from {A, B} and even {A, B, E}.
  It really depends upon the constraint on how <#Package{}> is 
  consumed.

  Infact one could implement something a well defined struct like:

  defmodule Package do
    defstruct %{txnID: txnID, dt dt, packetname: packetname}
  end

  and implement a protocol that implements operations on a series
  of such Package flows:

  defprotocol TxnBlock do

  end

  defimpl TxnBlock, for: Package do
    ..
  end

  Or simply:
  
  defprotocol TxnBlock do
    @spec new(String.t) :: Package.t
    def new(stack_name)

    @spec transfer(String.t, String.t) :: Atom.t
    def transfer(stack_a, stack_b)
  end

  defmodule Package do
    defstruct %{txnID: txnID, dt dt, packetname: packetname}
    
    defimpl TxnBlock do
      ..
    end
  end

  """

  alias Stackdelivery.StackGen.Supervisor, as: StackSup
  # alias Stackdelivery.StoreGen.Supervisor, as: StoreSup
  alias Stackdelivery.{
    Stack,
    Store
  }

  @doc """
  create a new deque stack.
  Each time a stack is created, it's name and GenServer pid are 
  stored in an ets table, unless it already exists then an error is thrown.
  """
  def new(stack_name) do
    case shoot(stack_name) do
      {:ok, pid} -> Store.push [stack_name: pid]
      {:error, _} ->
        IO.puts "stack name already exists"
        :not_allowed
    end
  end

  defp shoot(stack_name), do: StackSup.shoot(stack_name)

  @doc """
  add to stack
  """
  def add(stack, val), do: Stack.push(stack, val)

  @doc """
  transfers from stack1 to stack2
  """
  @spec transfer(String.t, String.t) :: Map.t
  def transfer(stack1, stack2) do
    cond do
      !!Store.fetch(stack1) && !!Store.fetch(stack2) -> 
        Stack.push(stack2, Stack.pop(stack1))
        :commit
      true ->
        IO.puts "either of the stacks does not exist." 
        :invalid_transfer_rollback
    end
  end

  @spec copy(String.t, List.t) :: Atom.t
  def copy(stack1, stack_list) do
    with true <- Enum.all?(stack_list, &(!!Store.fetch(&1))),
    [{k1, v1}] <- Stack.peek(stack1),
    do: (
      Enum.each(stack_list, &(Stack.push(&1, [{k1, v1}])))
      :commit
    ),
    else: (other-> 
    case other do
      false ->
        IO.puts "Undefined stack in list or Empty list"
        :invalid_list_rollback 
      nil -> 
        IO.puts "Empty source stack"
        :empty_source
    end)
  end

  @spec copy_transfer(String.t, String.t, List.t) :: Atom.t
  def copy_transfer(stack1, stack2, stack_list) do
    # check if stack2 not exists in stack_list
    with true <- Enum.all?(stack_list, &(!(stack2 in &1))),
    # then copy stack1 first key to stack_list
    :commit <- copy(stack1, stack_list),
    # then transfer from stack1 to stack2
    do: transfer(stack1, stack2),
    else: (other -> 
      case other do
        false ->
          IO.puts "#{stack2} exists in stack list provided" 
          :stack_overlap
        reason -> reason
      end
    )
  end
end