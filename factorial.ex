fib = fn(n) -> Enum.reduce(1..n, 0, fn(num, ac1) -> num + ac1 end) end