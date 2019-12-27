#!/usr/bin/env ruby

require_relative "../utils/computer"

@instructions = <<-EOS
OR A J
AND B J
AND C J
NOT J J
AND D J
OR E T
OR H T
AND T J
RUN
EOS

@output = -> (data) do
  @damage = data
end

Computer.new(output: @output).
  receive_ascii(@instructions).
  execute

p @damage
