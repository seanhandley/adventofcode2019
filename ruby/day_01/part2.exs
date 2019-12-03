#! /usr/bin/env elixir

defmodule FuelCounter do
  def cost(weight) when weight <= 0 do
    0
  end
  def cost(weight) do
    fuel = div(weight, 3) - 2
    cost(fuel) + Enum.max([fuel, 0])
  end
end

IO.read(:stdio, :all)
|> String.split("\n")
|> Enum.map(&String.to_integer/1)
|> Enum.map(&FuelCounter.cost/1)
|> Enum.sum()
|> IO.inspect()