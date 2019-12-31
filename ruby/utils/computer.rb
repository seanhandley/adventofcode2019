require "securerandom"

class Memory < Array
  def read(location)
    grow location
    fetch location
  end

  def write(location, value)
    grow location
    self[location] = value
  end

  private

  def grow(location)
    if location >= size
      until size == location + 1
        push 0
      end
    end
  end
end

class Computer
  attr_reader :memory

  def initialize(program: nil, output: nil, ready: nil,
                 id: nil, debug: false, block_io: true)
    @ready = ready
    @id = id || SecureRandom.hex(4)
    @in = Queue.new
    @memory = Memory.new(program || Computer.fetch_program_from_stdin)
    @output = output || -> (msg) { puts msg unless @debug }
    @pos = 0
    @debug = debug
    @block_io = block_io
    @relative_base = 0
  end

  def idle?
    @in.empty?
  end

  def receive(input)
    debug "RECEIVED #{input}"
    @in << input
    self
  end

  def receive_ascii(input)
    debug "RECEIVED ASCII #{input.inspect}"
    input.chars.map(&:ord).each do |c|
      @in << c
    end
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
      arg = @pos + i + 1
      case operand_modes[i]
      when 0
        debug "READ ARG #{i} from position #{@memory.read(arg)}"
        @memory.read(arg)
      when 1
        debug "READ ARG #{i} from absolute position #{arg}"
        arg
      when 2
        debug "READ ARG #{i} from relative position #{@relative_base + @memory.read(arg)}"
        @relative_base + @memory.read(arg)
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
    @memory.read(@pos).to_s.rjust(5, "0")
  end

  def fetch_instruction(number)
    {
      1 => -> (a, b, c) do
        res = @memory.read(a) + @memory.read(b)
        debug "ADD #{@memory.read(a)} + #{@memory.read(b)} = #{res}"
        store(res, c).tap { @pos += 4 }
      end,
      2 => -> (a, b, c) do
        res = @memory.read(a) * @memory.read(b)
        debug "MUL #{@memory.read(a)} x #{@memory.read(b)} = #{res}"
        store(res, c).tap { @pos += 4 }
      end,
      3 => -> (a) do
        if @ready
          Thread.new { sleep 0.0001; @ready.call }
        end
        val = @in.pop(!@block_io) rescue -1
        debug "INPUT #{val}"
        store(val, a).tap { @pos += 2 }
      end,
      4 => -> (a) do
        debug "OUTPUT #{@memory.read(a)}"
        @output.call(@memory.read(a)).tap { @pos += 2 }
      end,
      5 => -> (a, b) do
        res = @memory.read(a).nonzero?
        msg = "JNZ loc #{a} is #{@memory.read(a)}"
        msg << " (jumping to loc #{@memory.read(b)})" if res
        msg << " (no jump)" if !res
        debug msg
        res ? @pos = @memory.read(b) : @pos += 3
      end,
      6 => -> (a, b) do
        res = @memory.read(a).zero?
        msg = "JEZ loc #{a} is #{@memory.read(a)}"
        msg << " (jumping to loc #{@memory.read(b)})" if res
        msg << " (no jump)" if !res
        debug msg
        res ? @pos = @memory.read(b) : @pos += 3
      end,
      7 => -> (a, b, c) do
        res = @memory.read(a) < @memory.read(b)
        debug "LT #{@memory.read(a)} < #{@memory.read(b)} = #{res}"
        store(res ? 1 : 0, c).tap { @pos += 4 }
      end,
      8 => -> (a, b, c) do
        res = @memory.read(a) == @memory.read(b)
        debug "EQ #{@memory.read(a)} == #{@memory.read(b)} = #{res}"
        store(res ? 1 : 0, c).tap { @pos += 4 }
      end,
      9 => -> (a) do
        @relative_base += @memory.read(a)
        debug "RB #{@relative_base}"
        @pos += 2
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
    puts "[#{@id}][#{@pos}] #{msg}" if @debug
  end
end
