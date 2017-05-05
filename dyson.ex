defmodule Dyson do
    @doc """
    in base 10
    """
    def dyson(n), do: smallest_num(n, [n])

    def mul_head(n, alist, carry \\ 0) do
        h = case alist do
            [h | t] -> h
            [h] -> h
        end
        (h*n + carry) |> round |> Integer.digits
    end

    def agg(n, alist) when is_list(alist), do: mul_head(n, alist)

    def agg(n, carry, alist) when is_list(alist), do: mul_head(n, alist, carry)

    def case_carry(res, n, alist) do
        res
        |> case do
            [carry, num] -> smallest_num(n, carry, [num | alist])
            [num] -> smallest_num(n, [num | alist])
        end
    end

    def smallest_num(n, alist \\ [])
    def smallest_num(n, [1 | t] = alist) when is_list(alist), do: alist |> Integer.undigits
    def smallest_num(n, alist) when is_list(alist), do: agg(n, alist) |> case_carry(n, alist)
    def smallest_num(n, 0, [1 | t] = alist) when is_list(alist), do: alist |> Integer.undigits
    def smallest_num(n, carry, alist) when is_list(alist), do: agg(n, carry, alist) |> case_carry(n, alist)
end