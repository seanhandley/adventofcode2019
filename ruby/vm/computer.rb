require "securerandom"

require_relative "./input"
require_relative "./output"
require_relative "./memory"

module VM
  class Computer
    attr_reader :memory

    def initialize(program: nil, output: nil, ready: nil,
                   id: nil, debug: false, wait_for_input: true, buffer_output: false)
      @ready = ready
      @id = id || SecureRandom.hex(4)
      @input = Input.new(blocking: wait_for_input)
      @memory = Memory.new(program || Computer.fetch_program_from_stdin)
      @cb = output || -> (msg) { puts msg unless @debug }
      @output = (buffer_output ? BufferedOutput : SimpleOutput).new(cb: @cb)
      @instruction_pointer = 0
      @debug = debug
      @relative_base = 0
    end

    def idle?
      @input.empty?
    end

    def receive(input)
      debug "RECEIVED #{input.inspect}"
      @input.write(input)
      self
    end

    def execute_async
      Thread.new do
        loop do
          executable_instruction.(*operands)
        rescue => e
          debug(e)
          raise
        end
      end.tap { |t| t.send(:at_exit) { debug("CORE DUMP: #{@memory}") } }
    end

    def execute
      execute_async.join
      self
    end

    def self.fetch_program_from_stdin
      (@program ||= STDIN.read.split(",").map(&:to_i)).dup
    end

    private

    def executable_instruction
      fetch_instruction(instr_number)
    end

    def operands
      executable_instruction.arity.times.map do |i|
        arg = @instruction_pointer + i + 1
        case operand_modes[i]
        when 0
          debug "READ ARG #{i} from position #{@memory.read(arg)}"
          @memory.read(arg)
        when 1
          debug "READ ARG #{i} from absolute position #{arg}"
          arg
        when 2
          debug "READ ARG #{i} from relative position #{@memory.offset + @memory.read(arg)}"
          @memory.offset + @memory.read(arg)
        end
      end
    end

    def instr_number
      raw_instruction[-2, 2].to_i
    end

    def operand_modes
      raw_instruction[0, 3].chars.map(&:to_i).reverse
    end

    def raw_instruction
      @memory.read(@instruction_pointer).to_s.rjust(5, "0")
    end

    def fetch_instruction(number)
      {
        1 => -> (a, b, c) do
          res = @memory.read(a) + @memory.read(b)
          debug "ADD #{@memory.read(a)} + #{@memory.read(b)} = #{res}"
          store(res, c).tap { @instruction_pointer += 4 }
        end,
        2 => -> (a, b, c) do
          res = @memory.read(a) * @memory.read(b)
          debug "MUL #{@memory.read(a)} x #{@memory.read(b)} = #{res}"
          store(res, c).tap { @instruction_pointer += 4 }
        end,
        3 => -> (a) do
          if @ready
            Thread.new { sleep 0.0001; @ready.call }
          end
          val = @input.read
          debug "INPUT #{val}"
          store(val, a).tap { @instruction_pointer += 2 }
        end,
        4 => -> (a) do
          debug "OUTPUT #{@memory.read(a)}"
          @output.write(@memory.read(a)).tap { @instruction_pointer += 2 }
        end,
        5 => -> (a, b) do
          res = @memory.read(a).nonzero?
          msg = "JNZ loc #{a} is #{@memory.read(a)}"
          msg << " (jumping to loc #{@memory.read(b)})" if res
          msg << " (no jump)" if !res
          debug msg
          res ? @instruction_pointer = @memory.read(b) : @instruction_pointer += 3
        end,
        6 => -> (a, b) do
          res = @memory.read(a).zero?
          msg = "JEZ loc #{a} is #{@memory.read(a)}"
          msg << " (jumping to loc #{@memory.read(b)})" if res
          msg << " (no jump)" if !res
          debug msg
          res ? @instruction_pointer = @memory.read(b) : @instruction_pointer += 3
        end,
        7 => -> (a, b, c) do
          res = @memory.read(a) < @memory.read(b)
          debug "LT #{@memory.read(a)} < #{@memory.read(b)} = #{res}"
          store(res ? 1 : 0, c).tap { @instruction_pointer += 4 }
        end,
        8 => -> (a, b, c) do
          res = @memory.read(a) == @memory.read(b)
          debug "EQ #{@memory.read(a)} == #{@memory.read(b)} = #{res}"
          store(res ? 1 : 0, c).tap { @instruction_pointer += 4 }
        end,
        9 => -> (a) do
          @memory.adjust_offset(@memory.read(a))
          debug "RB #{@memory.offset}"
          @instruction_pointer += 2
          @relative_base
        end,
        99 => -> () { debug "HALT"; Thread.exit }
      }[number]
    end

    def store(value, location)
      debug "WRITE #{value} to #{location}"
      @memory.write(location, value)
    end

    def debug(msg)
      puts "[#{@id}][#{@instruction_pointer}] #{msg}" if @debug
    end
  end
end
