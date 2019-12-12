#!/usr/bin/env ruby

# --- Part Two ---
#
# All this drifting around in space makes you wonder about the nature of the universe. Does history really repeat itself? You're curious whether the moons will ever return to a previous state.
#
# Determine the number of steps that must occur before all of the moons' positions and velocities exactly match a previous point in time.
#
# For example, the first example above takes 2772 steps before they exactly match a previous point in time; it eventually returns to the initial state:
#
# After 0 steps:
# pos=<x= -1, y=  0, z=  2>, vel=<x=  0, y=  0, z=  0>
# pos=<x=  2, y=-10, z= -7>, vel=<x=  0, y=  0, z=  0>
# pos=<x=  4, y= -8, z=  8>, vel=<x=  0, y=  0, z=  0>
# pos=<x=  3, y=  5, z= -1>, vel=<x=  0, y=  0, z=  0>
#
# After 2770 steps:
# pos=<x=  2, y= -1, z=  1>, vel=<x= -3, y=  2, z=  2>
# pos=<x=  3, y= -7, z= -4>, vel=<x=  2, y= -5, z= -6>
# pos=<x=  1, y= -7, z=  5>, vel=<x=  0, y= -3, z=  6>
# pos=<x=  2, y=  2, z=  0>, vel=<x=  1, y=  6, z= -2>
#
# After 2771 steps:
# pos=<x= -1, y=  0, z=  2>, vel=<x= -3, y=  1, z=  1>
# pos=<x=  2, y=-10, z= -7>, vel=<x= -1, y= -3, z= -3>
# pos=<x=  4, y= -8, z=  8>, vel=<x=  3, y= -1, z=  3>
# pos=<x=  3, y=  5, z= -1>, vel=<x=  1, y=  3, z= -1>
#
# After 2772 steps:
# pos=<x= -1, y=  0, z=  2>, vel=<x=  0, y=  0, z=  0>
# pos=<x=  2, y=-10, z= -7>, vel=<x=  0, y=  0, z=  0>
# pos=<x=  4, y= -8, z=  8>, vel=<x=  0, y=  0, z=  0>
# pos=<x=  3, y=  5, z= -1>, vel=<x=  0, y=  0, z=  0>
#
# Of course, the universe might last for a very long time before repeating. Here's a copy of the second example from above:
#
# <x=-8, y=-10, z=0>
# <x=5, y=5, z=10>
# <x=2, y=-7, z=3>
# <x=9, y=-8, z=-3>
#
# This set of initial positions takes 4686774924 steps before it repeats a previous state! Clearly, you might need to find a more efficient way to simulate the universe.
#
# How many steps does it take to reach the first state that exactly matches a previous state?

require "set"

Pos = Struct.new(:x, :y, :z)
Moon = Struct.new(:pos, :vel)

@moons = STDIN.read.split("\n").map do |line|
  pos = Pos.new *line.match(/x=(\-?\d+), y=(\-?\d+), z=(\-?\d+)/)[1,3].map(&:to_i)
  Moon.new pos, Pos.new(0, 0, 0)
end

@prev_x = Set.new
@prev_y = Set.new
@prev_z = Set.new

@x_rep, @y_rep, @z_rep = false, false, false

@i = 0

def axis_positions(axis)
  @moons.map { |moon|[moon[:pos][axis], moon[:vel][axis]] }
end

loop do  
  if !@x_rep && @prev_x.member?(axis_positions(:x))
    @x_rep = @i
  end
  if !@y_rep && @prev_y.member?(axis_positions(:y))
    @y_rep = @i
  end
  if !@z_rep && @prev_z.member?(axis_positions(:z))
    @z_rep = @i
  end

  if @x_rep && @y_rep && @z_rep
    p [@x_rep, @y_rep, @z_rep].reduce(1, :lcm)
    break
  end

  @prev_x << axis_positions(:x) unless @x_rep
  @prev_y << axis_positions(:y) unless @y_rep
  @prev_z << axis_positions(:z) unless @z_rep

  @moons.combination(2).each do |a, b|
    [:x, :y, :z].each do |axis|
      if a[:pos][axis] > b[:pos][axis]
        a[:vel][axis] -= 1
        b[:vel][axis] += 1
      elsif a[:pos][axis] < b[:pos][axis]
        a[:vel][axis] += 1
        b[:vel][axis] -= 1
      end
    end
  end
  @moons.each do |moon|
    [:x, :y, :z].each do |axis|
      moon[:pos][axis] += moon[:vel][axis]
    end
  end
  @i += 1
end
