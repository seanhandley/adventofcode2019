#!/usr/bin/env ruby

require_relative "./advent8.1"

@layers = @layers.map { |layer| layer.each_slice(WIDTH).to_a }

top, *rest = @layers

BLACK = " "
WHITE = "█"

@merged_layer = rest.each_with_object(top) do |layer, merge|
  layer.each_with_index do |row, i|
    row.each_with_index do |col, j|
      merge[i][j] = ([merge[i][j]] + [col]).flatten
    end
  end
end

def char(pixel)
  pixel.reject { |el| el == 2 }.first.zero? ? BLACK : WHITE
end

@merged_layer.each do |row|
  puts row.map { |col| char(col) }.join
end
