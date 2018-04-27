# using reductive range technique
fact = fn(n) -> Enum.reduce(1..n, 1, fn(num, ac1) -> num * ac1 end) end


defmodule Factorial do
    @moduledoc """
    Factorial using optimal tail recursion
    You can use a debugger tracer for debugging:
    :dbg.tracer()
    {:ok, #PID<0.74.0>}
    iex(8)> :dbg.p(:all, :c)
    {:ok, [{:matched, :nonode@nohost, 44}]}
    iex(9)> :dbg.tpl(Factorial, :fact, [])
    {:ok, [{:matched, :nonode@nohost, 2}]}
    iex(10)> fact 5
    (<0.58.0>) call 'Elixir.Factorial':fact(5)
    (<0.58.0>) call 'Elixir.Factorial':fact(1,1,5)
    (<0.58.0>) call 'Elixir.Factorial':fact(2,2,5)
    (<0.58.0>) call 'Elixir.Factorial':fact(3,6,5)
    (<0.58.0>) call 'Elixir.Factorial':fact(4,24,5)
    (<0.58.0>) call 'Elixir.Factorial':fact(5,120,5)

    """
    def fact(x) do
        fact(1, 1, x)
    end

    defp fact(num, res, x) when num<x do
        # IO.puts res
        fact(num+1, res*(num+1), x)
    end

    defp fact(num, res, x) do
        res
    end

end