#!/usr/bin/env ruby

require_relative "../vm/computer"

@tiles = []

@x, @y = nil, nil

@output = -> (data) do
  if @x.nil?
    @x = data
  elsif @y.nil?
    @y = data
  else
    @tiles[@y] ||= []
    @tiles[@y][@x] = data
    @x = nil
    @y = nil
  end
end

VM::Computer.new(output: @output).execute

p @tiles.flatten.select { |t| t == 2 }.count
