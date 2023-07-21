input = [1, [2, 3, [nil, nil, 34], 76, 4], [23, 543], [343, [435]], 23, 43]
tests = %{
  "flatten" => fn -> FlattenArray.flatten(input) end,
  "flatten_tail" => fn -> FlattenArray.flatten_tail(input) end
}

Benchee.run(tests)
