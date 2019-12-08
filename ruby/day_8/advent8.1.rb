#!/usr/bin/env ruby

pixels = STDIN.read.chars.map(&:to_i)

WIDTH=25
HEIGHT=6
RESOLUTION = HEIGHT * WIDTH

@layers = pixels.each_slice(RESOLUTION).to_a

if __FILE__ == $0
  fewest_zeroes = @layers.min_by do |layer|
    layer.count(&:zero?)
  end

  p fewest_zeroes.count { |el| el == 1 } * fewest_zeroes.count { |el| el == 2 }
end
