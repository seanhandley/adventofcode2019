#!/usr/bin/env ruby

PHASES = 1

@input = STDIN.read.chars.map(&:to_i)
@current_value = @input.dup
@length = @current_value.length
@phase = 1
@base_pattern = [0, 1, 0, -1].cycle.take(@length + 1)

def pattern(i, j)
  @base_pattern[(i * j) % @length]
end

@t = Time.now

PHASES.times do
  @current_value = @current_value.each.with_index(0).map do |char, i|
    @current_value.each.with_index(1).sum do |el, j|
      pattern = pattern(i, j)
      puts "#{el} x #{pattern}"
      el * pattern
    end.abs.digits.first
  end
  puts "Completed phase #{@phase} in #{Time.now - @t}"
  @phase += 1
end

puts @current_value.join.rjust(@length, '0').chars.take(8).join
