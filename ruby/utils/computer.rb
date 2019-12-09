require "securerandom"

class Computer
  def initialize(program: nil, output: nil, id: nil, debug: false)
    @id = id || SecureRandom.hex(4)
    @in = Queue.new
    @memory = program || Computer.fetch_program_from_stdin
    @output = output || -> (msg) { puts msg unless @debug }
    @pos = 0
    @debug = debug
    @relative_base = 0
  end

  def receive(input)
    @in << input
    self
  end

  def execute_async
    Thread.new do
      loop do
        instr_number, instr, operands = decode
        debug "RAW: #{raw_instruction}"
        debug "#{instr_name(instr_number)}(#{operands.join(', ')})"
        instr.(*operands)
      rescue => e
        debug(e)
        raise
      end
    end
  end

  def execute
    execute_async.join
  end

  def self.fetch_program_from_stdin
    (@program ||= STDIN.read.split(",").map(&:to_i)).dup
  end

  private

  def decode
    [instr_number, executable_instruction, operands]
  end

  def executable_instruction
    fetch_instruction(instr_number)
  end

  def operands
    executable_instruction.arity.times.map do |i|
      loc = case operand_modes[i]
            when 0
              @memory[@pos + i + 1]
            when 1
              @pos + i + 1
            when 2
              @relative_base + @memory[@pos + i + 1]
            end
      loc.tap do |val|
        debug "READ[#{loc}] => #{val}"
        if loc >= @memory.count
          until @memory.count == loc
            @memory << 0
          end
        end
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
    @memory[@pos].to_s.rjust(5, "0")
  end

  def fetch_instruction(number)
    {
      1 => -> (a, b, c) { store(@memory[a] + @memory[b], c); @pos += 4 },
      2 => -> (a, b, c) { store(@memory[a] * @memory[b], c); @pos += 4 },
      3 => -> (a) { store(@in.pop, a); @pos += 2 },
      4 => -> (a) { @output.call(@memory[a]); @pos += 2 },
      5 => -> (a, b) { @memory[a].nonzero? ? @pos = @memory[b] : @pos += 3 },
      6 => -> (a, b) { @memory[a].zero? ? @pos = @memory[b] : @pos += 3 },
      7 => -> (a, b, c) { store(@memory[a] < @memory[b] ? 1 : 0, c) ; @pos += 4 },
      8 => -> (a, b, c) { store(@memory[a] == @memory[b] ? 1 : 0, c) ; @pos += 4 },
      9 => -> (a) { @relative_base += @memory[a]; @pos += 2 },
      99 => -> () { debug("CORE DUMP: #{@memory}") ; Thread.exit }
    }[number]
  end

  def store(value, location)
    @memory[location] = value
    debug "WRITE[#{location}] <= #{value}"
  end

  def instr_name(number)
    {
      1 => "ADD",
      2 => "MUL",
      3 => "IN",
      4 => "OUT",
      5 => "JNZ",
      6 => "JEZ",
      7 => "LT",
      8 => "EQ",
      9 => "RB",
      99 => "HALT",
    }[number]
  end

  def debug(msg)
    puts "[#{@id}] #{msg}" if @debug
  end
end
