defmodule Fibo do
    @moduledoc """
    doing fibonacci the tail-recursive way
    """
    
    @doc """
    cumbersome yet efficient, no stack tracking
    """
    def fib(x) do
        acc = 0
        start = 1
        fib(start, acc, x)
    end

    defp fib(start, acc, x) when acc <= x do
        tmp = acc
        acc = acc + start
        start = tmp
        fib(start, acc, x)
    end

    defp fib(start, acc, x) do
        acc
    end
end

Fibo.fib 5

defmodule FibTail do
    @moduledoc """
    the non-tail recursive way
    """
    def fib(0) do 0 end
    def fib(1) do 1 end
    def fib(n) do fib(n-1) + fib(n-2) end 
end

FibTail.fib 5