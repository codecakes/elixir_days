# using reductive range technique
fact = fn(n) -> Enum.reduce(1..n, 1, fn(num, ac1) -> num * ac1 end) end


defmodule Factorial do
    @moduledoc """
    Factorial using optimal tail recursion
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