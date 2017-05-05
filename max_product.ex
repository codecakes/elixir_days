defmodule MaxProduct do

  def divide(1, [num]), do: [num]

  def divide(n, arr) do
    {l, r} = Enum.split(arr, div(n,2))
    l_res = divide(l |> length, l)
    r_res = divide(r |> length, r)
    Enum.sort(l_res ++ r_res, &(&1 > &2)) |> Enum.take(2)
  end

  def findmax(n, arr) do
    [max, second_max] = divide(n, arr)
    max * second_max
  end

end

IO.inspect MaxProduct.findmax(3, [1,2,3]) == 6

IO.inspect MaxProduct.findmax(3, [3,2,1]) == 6

IO.inspect MaxProduct.findmax(10, [7, 5, 14, 2, 8, 8, 10, 1, 2, 3]) == 140

IO.inspect MaxProduct.findmax(5, [4, 6, 2, 6, 1]) == 36