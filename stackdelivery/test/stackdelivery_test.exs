defmodule StackdeliveryTest do
  use ExUnit.Case, async: true
  doctest Stackdelivery

  setup do
    :ok  
  end

  test "creates a stack" do
    assert :ok == Stackdelivery.new("stack1")
  end

  test "creates two different stack pids" do
    assert :ok == Stackdelivery.new("stack2")
    assert :ok == Stackdelivery.new("stack3")
  end

  test "transfer from one stack to another stack" do
    Stackdelivery.new("stack2")
    Stackdelivery.new("stack3")
    assert :commit == Stackdelivery.transfer("stack2", "stack3")
  end

  # test "copy and transfer from one stack" do
  #   assert Stackdelivery.new("stack1")
  #   assert Stackdelivery.new("stack2")
  #   assert Stackdelivery.new("stack3")
  #   assert Stackdelivery.new("stack4")
  #   assert :commit == Stackdelivery.transfer("stack2", "stack3")
  # end

end
