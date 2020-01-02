#!/usr/bin/env ruby

require_relative "../vm/computer"

@program = VM::Computer.fetch_program_from_stdin
@program[0] = 2
@instructions = File.read("instructions.txt")

VM::Computer.new(program: @program, output: -> (data) { @dust = data }).
  receive(@instructions).
  execute

p @dust
