defmodule Mystery do                  
 def sum(a, b) when (a > 1 and b > 4) do
 	a + b + sum(a-1, b-1)                  
 end
 def sum(1, 4), do: 5
end

