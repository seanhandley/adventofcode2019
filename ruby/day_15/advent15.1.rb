#!/usr/bin/env ruby

require_relative "../vm/computer"

def draw_screen
  print "\e[2J\e[f"
  @tiles.each do |row|
    puts row.join
  end
end

GRID_SIZE = 50

@tiles = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { " " } }
@x = @y = GRID_SIZE / 2
@last_move = 1

def set_wall
  @tiles[@y][@x] = "D"
  case @last_move
  when 1
    @tiles[@y-1][@x] = "#"
  when 2
    @tiles[@y+1][@x] = "#"
  when 3
    @tiles[@y][@x-1] = "#"
  when 4
    @tiles[@y][@x+1] = "#"
  end
end

def move_droid
  @tiles[@y][@x] = "."
  case @last_move
  when 1
    @y -= 1  
  when 2
    @y += 1
  when 3
    @x -= 1
  when 4
    @x += 1
  end
  @tiles[@y][@x] = "D"
end

def found_oxygen
  @tiles[@y][@x] = "D"
  case @last_move
  when 1
    @tiles[@y-1][@x] = "O"
  when 2
    @tiles[@y+1][@x] = "O"
  when 3
    @tiles[@y][@x-1] = "O"
  when 4
    @tiles[@y][@x+1] = "O"
  end
end

@output = -> (data) do
  case data
  when 0
    set_wall
  when 1
    move_droid
  when 2
    found_oxygen
    draw_screen
    exit 0
  end
  draw_screen
  key = [:up, :down, :left, :right].sample
  case key
  when "q"
    exit 0
  when :up
    @last_move = 1
    @droid.receive(@last_move)
  when :down
    @last_move = 2
    @droid.receive(@last_move)
  when :left
    @last_move = 3
    @droid.receive(@last_move)
  when :right
    @last_move = 4
    @droid.receive(@last_move)
  else
    @droid.receive(0)
  end
end

@program = File.read("input.txt").split(",").map(&:to_i)
@droid = VM::Computer.new(program: @program, output: @output, debug: false)

@droid.receive(@last_move)
@droid.execute
