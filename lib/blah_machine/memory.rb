module BlahMachine
  class Memory
    class AddressIsOutOfRange < StandardError; end;

    # Instructions
    IDLE = 0
    READ = 1
    WRITE = 2

    # Registers
    REGISTER_C0 = 0
    REGISTER_D0 = 10

    def initialize(capacity)
      @data  = (0..capacity-1).to_a.map { MachineWord.new(nil) }
      @capacity = capacity
    end

    def capacity
      @data.size
    end

    def write(address, value)
      if address < 0 || address >= @capacity
        raise AddressIsOutOfRange.new("Address '#{address}' is out of range 0 - #{@capacity}")
      end

      @data[address] = MachineWord.new(value)
    end

    def read(address)
      @data[address].value
    end
  end
end
