defmodule Solution do
  @moduledoc """
  See:
  https://www.hackerrank.com/challenges/permutation-equation/problem?utm_campaign=challenge-recommendation&utm_medium=email&utm_source=30-day-campaign
  """

  def take_inputs() do
    n = IO.gets("") |> String.trim_trailing() |> String.to_integer()

    IO.gets("")
    |> String.trim_trailing()
    |> String.split()
    |> Enum.map(&String.to_integer(&1))
    |> process(n)
  end

  def process([_head | _tail] = seq_list, n) when is_list(seq_list) do
    Enum.reduce(1..n, [%{}, seq_list], fn i, [dct, [h | t]] ->
      [Map.update(dct, h, i, & &1), t]
    end)
    |> List.first()
    |> result(n)
  end

  def result(pos_dct, n, idx_x \\ 1)

  def result(%{} = pos_dct, n, n) do
    val = pos_dct |> Map.get(n)
    pos_dct |> Map.get(val) |> IO.puts()
  end

  def result(%{} = pos_dct, n, idx_x) do
    val = pos_dct |> Map.get(idx_x)
    pos_dct |> Map.get(val) |> IO.puts()
    result(pos_dct, n, idx_x + 1)
  end
end

Solution.take_inputs()
