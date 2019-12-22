#!/usr/bin/env ruby

@formulae = STDIN.read.split("\n").each_with_object({}) do |formula, out|
  input, output = formula.split("=>")
  quantity, name = output.split
  inputs = input.split(", ").map{ |i| i.split }
  out[name] = {
    quantity: quantity.to_i,
    deps: inputs.map { |quantity, dep_name| [dep_name, quantity.to_i] }.to_h
  }
end

@ore_needed = 0
@leftovers = @formulae.keys.each_with_object({}) { |name, obj| obj[name] = 0 }

def cost(name, desired_quantity)
  if name == "ORE"
    @ore_needed += desired_quantity
  else
    output_quantity = @formulae[name][:quantity]
    @formulae[name][:deps].each do |dep_name, quantity|
      needed = (output_quantity / quantity.to_f).ceil
      needed.times { cost(dep_name, quantity) }
    end
  end
end

cost("FUEL", 1)

p @ore_needed