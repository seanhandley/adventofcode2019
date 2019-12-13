#!/usr/bin/env ruby

require "remedy"
require_relative "../utils/computer"

include Remedy

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
@screen = Viewport.new
@user_input = Interaction.new

def draw_screen
  content = Content.new
  @tiles.each do |row|
    content << row.map { |el| @sprites[el] }.join
  end
  content << "████████████ SCORE: #{@score.to_s.rjust(5, '0')} ████████████"
  @screen.draw content
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

@input = 0

@ready = -> do
  sleep 0.001
  draw_screen
  @computer.receive(direction)
  @input = 0
end

Thread.new do
  @user_input.loop do |key|
    case key.name
    when "q"
      exit 0
    when :up
      @input = 0
    when :right
      @input = 1
    when :left
      @input = -1
    else
      @input = 0
    end
  end
end

loop do
  @memory = File.read("input.txt").split(",").map(&:to_i)
  @memory[0] = 2
  @computer = Computer.new(program: @memory, output: @output, ready: @ready)
  @computer.execute
  draw_screen
  STDIN.getch
end
