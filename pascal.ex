defmodule Pascal do
    @moduledoc """
    # Pascal.addrow([0,1,0])
    # 0 | 1 | 0 

    # 0 | 1 | 1 | 0

    # 0 | 1 | 2 | 1 | 0

    # 0 | 1 | 3 | 3 | 1 | 0

    The pattern is simple to grasp.
    This is non-tail stac tracked recursive pattern matching.

    [0, 1, 0]

    => [0, 1] | [1, 0]
    => [1, 0] = [1+0] | [0]
    => [0, 1] [1] [0]
    ==========================================

    [0, 1, 1, 0]

    => [0, 1] | [1, 1, 0]

    => [1, 1, 0] = [1+1] | [1, 0]

    => [1, 0] = [1+0] | [0]

    => [0, 1] [2] [1] [0]
    ===========================================

    [0, 1, 2, 1, 0]

    => [0, 1] | [1, 2, 1, 0]

    => [1,2,1,0] = [1+2] | [2, 1, 0]
    => [2, 1, 0] = [2+1] | [1, 0]
    => [1, 0] = [1+0] | [0] 

    => [0, 1] [3] [3] [1] [0]
    ==========================================


    """

    @doc """
    @params
        - list: input a start list like [0, 1, 2, 1, 0]
    segregates first head = 0 
    """
    def addrow(list) do
        [head | tail] = list
        addrow head, tail
    end

    @doc """
    matches head=0 and tail list
    prepends and calls recursively
    """
    defp addrow(0, tail) do
        [head | tail] = tail
        [0 | [head] ++ addrow(head, tail)]
    end

    @doc """
    Base case:
    if tail is [0]
    append and return
    """
    defp addrow(head, [0]) do
        [head | [0]]
    end

    @doc """
    actual recursive function
    """
    defp addrow(head, tail) do
        h = head
        [head | tail] = tail
        [h+head] ++ addrow head, tail
    end

    # ========================================================

    @doc """
    Generates Pascal triangle/1 in a list 
    @params:
        - level: Takes a level starting no less than 1
    """
    def triangle(level) do
        cond do
             level >= 1 -> triangle [0, 1, 0], 1, level, [[0, 1, 0]]
             level < 1 -> IO.puts "This is not a valid input to generate a Pascal triangle"
        end
        
    end

    defp triangle(list, start_level, level, acc_list) when start_level < level do
        row = addrow(list)
        triangle row, start_level+1, level, [row | acc_list] 
    end

    defp triangle(list, start_level, level, acc_list) do
        Enum.reverse acc_list
    end

end
