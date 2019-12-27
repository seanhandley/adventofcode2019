#!/usr/bin/env ruby

require_relative "../utils/computer"

@program = Computer.fetch_program_from_stdin
@program[0] = 2

@dust = 0

@output = -> (data) do
  @dust = data
end

@instructions = File.read("instructions.txt").chars.map(&:ord)

@computer = Computer.new(output: @output, program: @program, debug: false)
@instructions.each do |instruction|
  @computer.receive(instruction)
end
@computer.execute

p @dust
