defmodule Stackdelivery do
  @moduledoc """
  Main Stackdelivery entry point.
  """
  alias Stackdelivery.StackGen.Supervisor, as: StackSup
  alias Stackdelivery.Stack

  def shoot(stack_name), do: StackSup.shoot(stack_name)

end