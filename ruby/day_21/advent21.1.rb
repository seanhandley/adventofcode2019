#!/usr/bin/env ruby

require_relative "../utils/computer"

@instructions = <<-EOS
OR A J
AND B J
AND C J
NOT J J
AND D J
WALK
EOS

@output = -> (data) do
  @damage = data
end

Computer.new(output: @output).
  receive_ascii(@instructions).
  execute

p @damage
