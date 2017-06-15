defmodule Stackdelivery do
  @moduledoc """
  Main Stackdelivery entry point.
  This app starts a bunch of stacks as building blocks and can be joined any which way transferring ejectile between two stacks.
  """
  alias Stackdelivery.StackGen.Supervisor, as: StackSup
  alias Stackdelivery.Stack

  @db %{}

  def new(stack_name) do
    case shoot(stack_name) do
      {:ok, pid} -> Map.put(@db, stack_name, pid)
      {:error, _} ->
        IO.puts "stack name already exists"
        :not_allowed
    end
  end

  defp shoot(stack_name), do: StackSup.shoot(stack_name)

end