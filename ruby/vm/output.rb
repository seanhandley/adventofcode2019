module VM
  class SimpleOutput
    def initialize(cb:)
      @cb = cb
    end

    def write(data)
      @cb.call(data)
    end
  end

  class BufferedOutput < SimpleOutput
    @buffer = []

    def initialize(cb:)
      @cb = cb
      @buffer = []
    end

    def write(data)
      @buffer << data
      if data == 10
        @cb.call(@buffer.map(&:chr).join).tap { @buffer = [] }
      end
    end
  end
end
