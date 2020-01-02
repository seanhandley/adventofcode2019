module VM
  class Memory < Array
    attr_reader :offset

    def initialize(*)
      @offset = 0
      super
    end

    def read(location)
      grow location
      fetch location
    end

    def write(location, value)
      grow location
      self[location] = value
    end

    def adjust_offset(incr)
      @offset += incr
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
end
