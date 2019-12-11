#!/usr/bin/env ruby

require_relative "../utils/computer"

@colour = nil
@directions = [:up, :right, :down, :left]
@panels = {}
@x, @y = 0, 0

def direction
  @directions.first
end

def turn(val)
  index = val == 0 ? -1 : 1
  @directions = @directions.cycle.each_cons(4).take(4)[index]
end

def move
  case direction
  when :up
    @y -= 1
  when :right
    @x += 1
  when :down
    @y += 1
  when :left
    @x -= 1
  end
end

def paint
  @panels[@y] ||= {}
  @panels[@y][@x] = @colour
end

def debug(msg)
  # puts msg
end

@output = -> (data) do
  if @colour.nil?
    debug "Set colour to: #{data}"
    @colour = data
  else
    debug "Painting #{@x},#{@y} colour #{@colour}"
    paint
    debug "Facing #{direction}"
    debug "Turning #{data == 0 ? 'left' : 'right' }"
    turn(data)
    debug "Facing #{direction}"
    move
    debug "Moved to #{@x},#{@y}"
    @colour = nil
    @robot.receive(@panels.dig(@y, @x) || 0)
  end
end

if __FILE__ == $0
  @robot = Computer.new(output: @output)
  @robot.receive(0)
  @robot.execute

  p @panels.values.map(&:values).flatten.count
end
