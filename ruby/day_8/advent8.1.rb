#!/usr/bin/env ruby

WIDTH = 25
HEIGHT = 6

def layers
  @layers ||= STDIN.read.
                    chars.
                    map(&:to_i).
                    each_slice(HEIGHT * WIDTH)
end

def fewest_zeroes
  layers.min_by { |layer| layer.count(&:zero?) }
end

if __FILE__ == $0
  p fewest_zeroes.count { |el| el == 1 } *
    fewest_zeroes.count { |el| el == 2 }
end
