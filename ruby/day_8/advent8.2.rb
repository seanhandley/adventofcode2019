#!/usr/bin/env ruby

require_relative "./advent8.1"

BLANK = " ".freeze
SOLID = "█".freeze

def merged_layer 
  top, *rest = layers.map { |layer| layer.each_slice(WIDTH).to_a }

  rest.each_with_object(top) do |layer, merge|
    layer.each_with_index do |row, i|
      row.each_with_index do |col, j|
        merge[i][j] = ([merge[i][j]] + [col]).flatten
      end
    end
  end
end

def colour(pixel)
  pixel.reject { |el| el == 2 }.first.zero? ? BLANK : SOLID
end

def print_image
  merged_layer.each do |row|
    puts row.map { |col| colour(col) }.join
  end
end

print_image
