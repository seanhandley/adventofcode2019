#!/usr/bin/env ruby

require_relative "../utils/computer"

@program = Computer.fetch_program_from_stdin
@program[0] = 2
@instructions = File.read("instructions.txt").chars.map(&:ord)

@computer = Computer.new(output: -> (o) { @dust = o }, program: @program)
@instructions.each(&@computer.method(:receive))
@computer.execute

p @dust
