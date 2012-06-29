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
    REGISTER_D1 = 11

    # status
    REGISTER_S0 = 100

    STATUS_OK = 0
    STATUS_ADDRESS_IS_OUT_OF_RANGE = 10

    REGISTER_INDEXES = [
      REGISTER_C0,
      REGISTER_D0,
      REGISTER_D1,
      REGISTER_S0
    ]

    attr_reader :data, :capacity, :registers

    def initialize(capacity)
      @data  = (0..capacity-1).to_a.map { MachineWord.new(nil) }
      @capacity = capacity

      @registers = {}
      initialize_registers
    end

    def next_cycle
      execute_current_instruction
    end

    def read_register(index)
      if REGISTER_INDEXES.include?(index)
        registers[index].value
      else
        raise UndefinedRegister.new("Register '#{index}' is udefined")
      end
    end

    def write_register(index, value)
      if REGISTER_INDEXES.include?(index)
        registers[index] = MachineWord.new(value)
      else
        raise UndefinedRegister.new("Register '#{index}' is udefined")
      end
    end

    private

    def execute_current_instruction
      case read_register(REGISTER_C0)
      when IDLE
        # do nothing
        write_register(REGISTER_S0, STATUS_OK)
      when READ
        begin
          write_register(REGISTER_D1, read(read_register(REGISTER_D0)))
          write_register(REGISTER_S0, STATUS_OK)
        rescue AddressIsOutOfRange
          write_register(REGISTER_S0, STATUS_ADDRESS_IS_OUT_OF_RANGE)
        end
      when WRITE
        begin
          write(read_register(REGISTER_D0), read_register(REGISTER_D1))
          write_register(REGISTER_S0, STATUS_OK)
        rescue AddressIsOutOfRange
          write_register(REGISTER_S0, STATUS_ADDRESS_IS_OUT_OF_RANGE)
        end
      end
    end

    def initialize_registers
      write_register(REGISTER_C0, IDLE)
      write_register(REGISTER_S0, STATUS_OK)
    end

    def write(address, value)
      data[address] = MachineWord.new(value)
    end

    def read(address)
      raise AddressIsOutOfRange.new("Address '#{address}' is out of range #{0} - #{capacity - 1}") if address >= capacity
      data[address].value
    end
  end
end
