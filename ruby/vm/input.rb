module VM
  class Input
    def initialize(blocking: true)
      @blocking = blocking
      @q = Queue.new
    end

    def write(input)
      case input
      when Integer
        @q << input
      when String
        input.chars.map(&:ord).each do |c|
          @q << c
        end
      end
    end

    def empty?
      @q.empty?
    end

    def read
      @q.pop(!@blocking) rescue -1
    end
  end
end
