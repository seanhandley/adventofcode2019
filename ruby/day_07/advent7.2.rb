#!/usr/bin/env ruby

# --- Part Two ---
#
# It's no good - in this configuration, the amplifiers can't generate a large enough output signal to produce the thrust you'll need. The Elves quickly talk you through rewiring the amplifiers into a feedback loop:
#
#       O-------O  O-------O  O-------O  O-------O  O-------O
# 0 -+->| Amp A |->| Amp B |->| Amp C |->| Amp D |->| Amp E |-.
#    |  O-------O  O-------O  O-------O  O-------O  O-------O |
#    |                                                        |
#    '--------------------------------------------------------+
#                                                             |
#                                                             v
#                                                      (to thrusters)
#
# Most of the amplifiers are connected as they were before; amplifier A's output is connected to amplifier B's input, and so on. However, the output from amplifier E is now connected into amplifier A's input. This creates the feedback loop: the signal will be sent through the amplifiers many times.
#
# In feedback loop mode, the amplifiers need totally different phase settings: integers from 5 to 9, again each used exactly once. These settings will cause the Amplifier Controller Software to repeatedly take input and produce output many times before halting. Provide each amplifier its phase setting at its first input instruction; all further input/output instructions are for signals.
#
# Don't restart the Amplifier Controller Software on any amplifier during this process. Each one should continue receiving and sending signals until it halts.
#
# All signals sent or received in this process will be between pairs of amplifiers except the very first signal and the very last signal. To start the process, a 0 signal is sent to amplifier A's input exactly once.
#
# Eventually, the software on the amplifiers will halt after they have processed the final loop. When this happens, the last output signal from amplifier E is sent to the thrusters. Your job is to find the largest output signal that can be sent to the thrusters using the new phase settings and feedback loop arrangement.
#
# Here are some example programs:
#
# Max thruster signal 139629729 (from phase setting sequence 9,8,7,6,5):
#
# 3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
# 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
#
# Max thruster signal 18216 (from phase setting sequence 9,7,8,5,6):
#
# 3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
# -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
# 53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10
#
# Try every combination of the new phase settings on the amplifier feedback loop. What is the highest signal that can be sent to the thrusters?

require_relative "../day_05/advent5.1"

def program
  (@program ||= STDIN.read.split(",").map(&:to_i)).dup
end

def permutations
  (5..9).to_a.permutation(5)
end

def find_possible_outputs
  permutations.map do |permutation|
    looped_execution(*permutation)
  end
end

def looped_execution(a, b, c, d, e)
  @in_queue_a = Queue.new
  @in_queue_a.push a
  @in_queue_a.push 0
  @input_device_a = -> { @in_queue_a.pop }
  @output_device_a = -> (data) { @in_queue_b.push(data) }

  @in_queue_b = Queue.new
  @in_queue_b.push b
  @input_device_b = -> { @in_queue_b.pop }
  @output_device_b = -> (data) { @in_queue_c.push(data) }

  @in_queue_c = Queue.new
  @in_queue_c.push c
  @input_device_c = -> { @in_queue_c.pop }
  @output_device_c = -> (data) { @in_queue_d.push(data) }

  @in_queue_d = Queue.new
  @in_queue_d.push d
  @input_device_d = -> { @in_queue_d.pop }
  @output_device_d = -> (data) { @in_queue_e.push(data) }

  @in_queue_e = Queue.new
  @in_queue_e.push e
  @input_device_e = -> { @in_queue_e.pop }
  @output_device_e = -> (data) { @in_queue_a.push(data) }

  threads = []

  threads << Thread.new { Computer.new(program, @input_device_a, @output_device_a).execute }
  threads << Thread.new { Computer.new(program, @input_device_b, @output_device_b).execute }
  threads << Thread.new { Computer.new(program, @input_device_c, @output_device_c).execute }
  threads << Thread.new { Computer.new(program, @input_device_d, @output_device_d).execute }
  threads << Thread.new { Computer.new(program, @input_device_e, @output_device_e).execute }

  threads.each { |t| t.join }
  @in_queue_a.pop
end

if __FILE__ == $0
  p find_possible_outputs.max
end