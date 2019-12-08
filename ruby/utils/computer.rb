class Computer
  def initialize(program: nil, output: nil)
    @queue = Queue.new
    @memory = program || Computer.fetch_program_from_stdin
    @output = output || -> (msg) { puts msg }
    @pos = 0
  end

  def receive(input)
    @queue << input
    self
  end

  def execute_async
    Thread.new do
      loop do
        instr, operands = decode
        instr.(*operands)
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
    [executable_instruction, operands]
  end

  def executable_instruction
    fetch_instruction(instr_number)
  end

  def operands
    executable_instruction.arity.times.map do |i|
      if operand_modes[i] == 1 || instr_number == 3
        @memory[@pos + i + 1]
      else
        @memory[@memory[@pos + i + 1]]
      end
    end
  end

  def instr_number
    raw_instruction[-2, 2].to_i
  end

  def operand_modes
    raw_instruction[0, 3].chars.map(&:to_i).reverse.tap { |m| m[2] = 1 }
  end

  def raw_instruction
    @memory[@pos].to_s.rjust(5, "0")
  end

  def fetch_instruction(number)
    {
      1 => -> (a, b, c) { @memory[c] = a + b; @pos += 4 },
      2 => -> (a, b, c) { @memory[c] = a * b; @pos += 4 },
      3 => -> (a) { @memory[a] = get_input; @pos += 2 },
      4 => -> (a) { write_output(a); @pos += 2 },
      5 => -> (a, b) { a.nonzero? ? @pos = b : @pos += 3 },
      6 => -> (a, b) { a.zero? ? @pos = b : @pos += 3 },
      7 => -> (a, b, c) { @memory[c] = (a < b) ? 1 : 0 ; @pos += 4 },
      8 => -> (a, b, c) { @memory[c] = (a == b) ? 1 : 0 ; @pos += 4 },
      99 => -> () { Thread.exit }
    }[number]
  end

  def get_input
    @queue.pop
  end

  def write_output(msg)
    @output.call(msg)
  end
end
