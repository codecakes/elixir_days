defmodule BinarySearch do
    @moduledoc """
    binary search on sorted list
    """

    @spec search(List.t, Integer.t, Integer.t, Item) :: {Item, Integer.t} | nil 
    # def search(alist, lo, hi, item)
    def search([], _lo, _hi, _item), do: nil
    def search([item], lo, hi, item), do: {item, idx_add(lo, hi)}
    def search(alist, lo, hi, item) do
        mid = idx_add(lo, hi)
        div_conquer(alist, item, lo, hi, mid)
    end

    defp div_conquer([h | _t], item, lo, lo, lo) when h > item, do: nil
    defp div_conquer(alist, item, lo, hi, mid) do
        item_found = Enum.at(alist, mid)
        cond do
            item_found == nil -> nil
            # if the item is found in the middle
            item_found == item -> {item, mid}
            # if the item found is greater than at mid
            item_found > item -> search(alist, lo, mid, item)
            # if the item found is less than at mid
            item_found < item -> search(alist, mid+1, hi, item)
        end
    end

    defp idx_add(lo, hi), do: lo + div(hi - lo, 2)

end

