#!/usr/bin/env ruby

require_relative "../utils/computer"

@buffer = ""

@output = -> (data) do
  @buffer << data.chr
end

computer = Computer.new(output: @output)
computer.execute

@grid = @buffer.split("\n").map { |row| row.chars }

def intersection?(x, y)
  return false unless @grid[y][x] == "#"
  [
    @grid.dig(y - 1, x),
    @grid.dig(y + 1, x),
    @grid.dig(y, x - 1),
    @grid.dig(y, x + 1)
  ].all? { |el| el == "#" }
end

@total = @grid.each_with_index.sum do |row, y|
  row.each_with_index.sum do |col, x|
    intersection?(x, y) ? (x * y) : 0
  end
end

p @total
