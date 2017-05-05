File.stream!(words.txt , [:utf8]) |> Stream.flat_map(fn(l) -> String.trim(l) |> String.split end) |> Enum.to_list |> Enum.reduce(%{}, fn(word, m) -> Map.update(m, word, 1, &(&1 + 1)) end)

