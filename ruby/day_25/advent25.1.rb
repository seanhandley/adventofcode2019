#!/usr/bin/env ruby

require_relative "../utils/computer"

@buffer = []

@output = -> (data) do
  @buffer << data
  if data == 10
    puts @buffer.map(&:chr).join
    @buffer = []
  end
end

@ready = -> do
  @computer.receive_ascii(gets)
end

@program = File.read("input.txt").split(",").map(&:to_i)

@computer = Computer.new(program: @program, output: @output, ready: @ready)
@computer.execute
