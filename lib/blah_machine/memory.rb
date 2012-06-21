module BlahMachine
  class Memory
    MAX_VALUE = 2 ** 16

    class AddressIsOutOfRange < StandardError; end;
    class ValueIsOutOfRange < StandardError; end;

    def initialize(capacity)
      @data  = Array.new(capacity, 0)
      @capacity = capacity
    end

    def capacity
      @data.size
    end

    def write(address, value)
      if address < 0 || address >= @capacity
        raise AddressIsOutOfRange.new("Address '#{address}' is out of range 0 - #{@capacity}")
      end

      if value < 0 || value > MAX_VALUE
        raise ValueIsOutOfRange.new("Value '#{value}' is out of range 0 - #{MAX_VALUE}")
      end

      @data[address] = value
    end

    def read(address)
      @data[address]
    end
  end
end
