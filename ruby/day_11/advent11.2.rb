#!/usr/bin/env ruby

require_relative "./advent11.1"

@robot = Computer.new(output: @output)
@robot.receive(1)
@robot.execute

@display = []

@panels.each do |y, rows|
  rows.each do |x, colour|
    @display[y] ||= []
    @display[y][x] = colour
  end
end

@display.each do |row|
  puts row.map { |el| el == 0 ? " " : "█"}.join
end
