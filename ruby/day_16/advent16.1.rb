#!/usr/bin/env ruby

PHASES = 1

@input = STDIN.read.chars.map(&:to_i)
@base_pattern = [0, 1, 0, -1].cycle
@current_value = @input.dup
@length = @current_value.length
@phase = 1

def pattern(pos)
  i = (pos % 4) % (pos + 1) + 1
  [0, 1, 0, -1][i]
end

@t = Time.now

PHASES.times do
  @current_value = @current_value.each.with_index(1).map do |char, i|
    pattern = @base_pattern.take(@length + 1).map do |el|
      i.times.map { el }
    end.flatten[1, @length]
    @current_value.zip(pattern).sum do |a, b|
      a * b
    end.abs.digits.first
  end
  puts "Completed phase #{@phase} in #{Time.now - @t}"
  @phase += 1
end

puts @current_value.join.rjust(@length, '0').chars.take(8).join
