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

# Solution.run

defmodule BetterSolution do
    
    def is_prime(n, n_sqrt, lo \\ 2)
    def is_prime(_, n_sqrt, hi) when hi > n_sqrt, do: []
    def is_prime(n, n_sqrt, lo) do
        case rem(n, lo) do
            0 -> [lo] ++ is_prime(n, n_sqrt, lo + 1)
            _ -> is_prime(n, n_sqrt, lo + 1)
        end
    end
    
    def find_prime(1), do: IO.puts "Not prime"
    def find_prime(2), do: IO.puts "Prime"   
    def find_prime(n) do
        n_sqrt = n |> :math.sqrt |> :math.ceil |> round
        case [n] ++ is_prime(n, n_sqrt) ++ [1] do
            [n, 1] -> IO.puts "Prime"
            _ -> IO.puts "Not prime"
        end
    end
    
    def run do
        r = IO.gets("") |> String.trim |> String.to_integer 
        Enum.map(Range.new(1, r), fn(_) -> 
            IO.gets("") |> String.trim |> String.to_integer |> find_prime
        end)
    end
end

BetterSolution.run
