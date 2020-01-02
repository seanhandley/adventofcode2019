#!/usr/bin/env ruby

require "set"
require_relative "../vm/computer"

RANGE = (0..49)

@output_buffers = RANGE.each_with_object({}) do |i, coll|
  coll[i] = []
end

@y_value_delivered_to_zero = nil

@output_handlers = RANGE.each_with_object({}) do |i, coll|
  coll[i] = -> (data) do
    case @output_buffers[i].length
    when 2
      id, a = @output_buffers[i]
      b = data
      if id == 255
        if @computers.values.all?(&:idle?)
          if @y_value_delivered_to_zero == b
            puts b
            exit
          else
            @y_value_delivered_to_zero = b
            @computers[0].receive(a)
            @computers[0].receive(b)
          end
        end
      else
        @computers[id].receive(a)
        @computers[id].receive(b)
      end
      @output_buffers[i] = []
    else
      @output_buffers[i] << data
    end
  end
end

@computers = RANGE.each_with_object({}) do |i, coll|
  coll[i] = VM::Computer.new(id: i, wait_for_input: false, output: @output_handlers[i]).receive(i)
end

@threads = @computers.values.map(&:execute_async)

@threads.map(&:join)
