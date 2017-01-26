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
    def fib(n, %{}=cache) when n <= 1, do: {n, cache}
    def fib(n, %{}=cache) when is_integer(n) do
        case Map.get(cache, n) do
            nil -> 
                {l, cache} = fib(n-1, cache)
                cache = Map.put(cache, n-1, l)
                {r, cache} = fib(n-2, cache)
                cache = Map.put(cache, n-2, r)
                {l+r, cache}
            res when is_integer(res) -> {res, cache}
        end
    end
    def fib(n) do
        {res, _} = fib(n, %{})
        res
    end
    
    
end

IO.inspect FibTail.fib 0
IO.inspect FibTail.fib 1
IO.inspect FibTail.fib 2
IO.inspect FibTail.fib 3
IO.inspect FibTail.fib 4
IO.inspect FibTail.fib 5
IO.inspect FibTail.fib 6
IO.inspect FibTail.fib 7
IO.inspect FibTail.fib 20
IO.inspect FibTail.fib 100
IO.inspect FibTail.fib 500