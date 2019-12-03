#! /usr/bin/env elixir

IO.read(:stdio, :all)
|> String.split("\n")
|> Enum.map(&String.to_integer/1)
|> Enum.map(fn (weight) -> div(weight, 3) - 2 end)
|> Enum.sum()
|> IO.inspect()
