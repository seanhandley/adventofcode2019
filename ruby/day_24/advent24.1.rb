#!/usr/bin/env ruby

require "set"

@grid = STDIN.read.split("\n").map(&:chars)

def adjacent_tiles(x, y)
  adjacent = []
  adjacent << @grid[y-1][x] if y > 0
  adjacent << @grid[y][x-1] if x > 0
  adjacent << @grid[y][x+1] if x < 4
  adjacent << @grid[y+1][x] if y < 4
  adjacent.compact
end

def next_bug(x, y)
  adjacent = adjacent_tiles(x, y).select { |t| t == "#" }.count
  adjacent == 1 ? "#" : "."
end

def next_space(x, y)
  adjacent = adjacent_tiles(x, y).select { |t| t == "#" }.count
  ((adjacent == 1) || (adjacent == 2)) ? "#" : "."
end

def tick
  new_grid = Array.new(5) { Array.new(5) }
  @grid.each_with_object([]).with_index do |(row, new_row), y|
    row.each_with_index do |el, x|
      case el
      when "."
        new_grid[y][x] = next_space(x, y)
      when "#"
        new_grid[y][x] = next_bug(x, y)
      end
    end
  end
  @grid = new_grid
end

def debug
  @grid.each do |row|
    p row
  end
end

@layouts = Set.new

loop do
  break if @layouts.member?(@grid)
  @layouts << @grid.dup
  tick
end

total = @grid.flatten.each_with_index.sum do |el, i|
  el == "#" ? 2 ** i : 0
end

p total