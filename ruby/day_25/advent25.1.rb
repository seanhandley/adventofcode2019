#!/usr/bin/env ruby

require_relative "../vm/computer"

@ready = -> do
  @computer.receive(gets)
end

@program = File.read("input.txt").split(",").map(&:to_i)

@computer = VM::Computer.new(program: @program, output: @output, ready: @ready, buffer_output: true)
@computer.execute
