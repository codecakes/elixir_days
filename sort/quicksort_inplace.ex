defmodule QuickSort do

    def sort(arr, lo, hi) when length(arr) > 1, do: cmp_swap(arr, lo, hi)

    def sort([], _, _), do: []
    def sort([num], lo, lo), do: [num]

    def cmp_swap(arr, i, pivot) when i < pivot do
        # IO.inspect i, label: "i is"
        # IO.inspect pivot, label: "pivot is"
        # IO.inspect arr, label: "arr is"
        with true <- Enum.at(arr, i) > Enum.at(arr, pivot) do
            case pivot-1 > i do
                true -> arr
                    |> swap(pivot, pivot-1)
                    |> swap(pivot, i)
                    |> cmp_swap(i, pivot-1)
                false -> arr
                    |> swap(pivot, pivot-1)
                    |> cmp_swap(i, pivot-1)
                    |> cmp_swap(i+1, length(arr) - 1)
            end
        else false -> arr |> cmp_swap(i + 1, pivot) 
        end
    end

    def cmp_swap([num], _, _), do: [num]

    def cmp_swap(arr, 0, _), do: arr

    def cmp_swap(arr, i, i) do
        # IO.inspect i, label: "i is"
        # IO.inspect i, label: "pivot is"
        # IO.inspect arr, label: "arr is"
        hi_idx = length(arr) - 1
        # IO.puts "left: #{Enum.slice(arr, 0, i) |> Enum.join(" ")}, 0, #{i-1} \n mid: #{i} -> #{[Enum.at(arr, i)] |> Enum.join(" ")} \n hi: #{Enum.slice(arr, i+1, hi_idx-i) |> Enum.join(" ")}, 0, #{hi_idx-i-1}"
        sort(Enum.slice(arr, 0, i), 0, i-1) ++ [Enum.at(arr, i)] ++ sort(Enum.slice(arr, i+1, hi_idx-i), 0, hi_idx-i-1)
    end

    def swap(arr, i, j) do
        [num1, num2] = [Enum.at(arr, i), Enum.at(arr, j)]
        # IO.puts "i: #{j} pivot: #{i} num1: #{num1} num2: #{num2}"
        List.replace_at(arr, i, num2) |> List.replace_at(j, num1)
        # IO.inspect a, label: "after swap"
    end
end

IO.puts QuickSort.sort([3,2,5,1, 5, 5], 0, 5) == [1, 2, 3, 5, 5, 5]
IO.puts QuickSort.sort([3,2,5,1, 5, 4], 0, 5) == [1, 2, 3, 4, 5, 5]