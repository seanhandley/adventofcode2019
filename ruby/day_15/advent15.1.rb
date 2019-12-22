#!/usr/bin/env ruby

require "remedy"
require_relative "../utils/computer"

include Remedy

@screen = Viewport.new
@user_input = Interaction.new

def draw_screen
  content = Content.new
  @tiles.each do |row|
    content << row.join
  end
  @screen.draw content
end

GRID_SIZE = 200

@tiles = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { " " } }
@x = @y = GRID_SIZE / 2
@last_move = 1

def set_wall
  @tiles[@y][@x] = "D"
  case @last_move
  when 1
    @tiles[@y-1][@x] = "#"
  when 2
    @tiles[@y+2][@x] = "#"
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
    @tiles[@y+2][@x] = "O"
  when 3
    @tiles[@y][@x-1] = "O"
  when 4
    @tiles[@y][@x+1] = "O"
  end
end

@output = -> (data) do
  p data
  case data
  when 0
    set_wall
  when 1
    move_droid
  when 2
    found_oxygen
  end
  draw_screen
  key = @user_input.get_key
  case key.name
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
  end
end

@program = File.read("input.txt").split(",").map(&:to_i)
@droid = Computer.new(program: @program, output: @output, debug: true)
@droid.receive(@last_move)
@droid.execute
