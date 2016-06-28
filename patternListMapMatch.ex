h = [%{age: 20, name: "a"}, %{age: 20, name: "b"}]

# will return the first found value that matches
Enum.find h, fn(m) ->
    Enum.all?([age: 20], fn({key, val})-> Map.get(m, key) == val end) 
end
