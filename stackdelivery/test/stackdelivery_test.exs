defmodule StackdeliveryTest do
  use ExUnit.Case, async: true
  doctest Stackdelivery

  setup do
    :ok  
  end

  test "creates a stack" do
    assert is_map Stackdelivery.new("stack1")
  end

  test "creates two different stack pids" do
    %{"stack2"=> pid2} = Stackdelivery.new("stack2")
    %{"stack3"=> pid3} = Stackdelivery.new("stack3")
    
    refute pid3 == pid2
  end

end
