#!/usr/bin/env ruby

require_relative "../utils/computer"

@program = Computer.fetch_program_from_stdin
@program[0] = 2
@instructions = File.read("instructions.txt")

Computer.new(program: @program, output: -> (data) { @dust = data }).
  receive_ascii(@instructions).
  execute

p @dust
