#!/usr/bin/env ruby

require_relative "../utils/computer"

@tiles = []
@sprites = {
  0 => " ",
  1 => "█",
  2 => "░",
  3 => "\b🚥",
  4 => "\b🏀"
}

@x, @y = nil, nil

@score = 0

def draw_screen
  print "\e[2J\e[f" # clear screen
  display = @tiles.map do |row|
    row.map { |el| @sprites[el] }.join
  end
  display << "████████████ SCORE: #{@score.to_s.rjust(5, '0')} ████████████"
  puts display.join("\n")
end

@output = -> (data) do
  if @x.nil?
    @x = data
  elsif @y.nil?
    @y = data
  else
    if @x == -1 && @y == 0
      @score = data
    else
      @tiles[@y] ||= []
      @tiles[@y][@x] = data
    end
    @x = nil
    @y = nil
  end
end

def ball_pos
  @tiles.each do |row|
    row.each_with_index do |col, i|
      return i if row[i] == 4
    end
  end  
end

def paddle_pos
  @tiles.each do |row|
    row.each_with_index do |col, i|
      return i if row[i] == 3
    end
  end  
end

def direction
  if paddle_pos == ball_pos
    0
  elsif paddle_pos > ball_pos
    -1
  else
    1
  end
end

@ready = -> do
  draw_screen
  @computer.receive(direction)
end

@memory = Computer.fetch_program_from_stdin
@memory[0] = 2
@computer = Computer.new(program: @memory, output: @output, ready: @ready)
@computer.execute
draw_screen
