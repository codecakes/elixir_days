defmodule Solution do
   
    def factorize(1, _), do: [1]
    
    def factorize(n ,t) do
        num = case div(t, n) do
            0 -> []
            x -> [x]
        end
        cond do
            rem(n, 2) == 0 -> 
                [n] ++ num ++ (div(n,2) |> factorize(t))
            rem(n, 3) == 0 -> 
                [n] ++ num ++ (div(n,3) |> factorize(t))
            true -> [n] ++ factorize(n-1, t)
        end
    end
    
    def is_prime(n) do
        half = cond do
            rem(n, 2) == 0 -> div(n, 2)
            rem(n, 3) == 0 -> div(n, 3)
            true -> :nil
        end
        
        res = case is_integer(half) do
            false -> [n, 1]
            true -> [n] ++ [div(n, half)] ++ factorize(half, n)
        end
        case (res |> Enum.uniq |> length) > 2 do
            true -> IO.puts "Not prime"
            false -> IO.puts "Prime"
        end
    end
    
    def run do
        r = IO.gets("") |> String.trim |> String.to_integer
        
        Enum.map(Range.new(1, r), fn(_) -> 
            IO.gets("") |> String.trim |> String.to_integer |> is_prime
        end)
    end
end

Solution.run
