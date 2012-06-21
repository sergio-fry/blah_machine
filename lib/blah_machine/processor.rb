module BlahMachine
  class Processor
    ###############################################
    # Registers inxedes

    # Command
    REGISTER_C0 = 0

    # Data
    REGISTER_D0 = 10
    REGISTER_D1 = 11

    # Result
    REGISTER_R0 = 20

    # RAM
    REGISTER_M0 = 30 # pointer to next command
    REGISTER_M1 = 31 # command
    REGISTER_M2 = 32 # data
    REGISTER_M3 = 33 # data

    REGISTER_INDEXES = [
      REGISTER_C0,
      REGISTER_D0,
      REGISTER_D1,
      REGISTER_R0,
      REGISTER_M0,
      REGISTER_M1,
      REGISTER_M2,
      REGISTER_M3
    ]

    attr_reader :registers

    def initialize
      @registers = {}
      initialize_registers
    end

    # start next processor cycle
    def next_cycle
      copy_command_and_data_from_memory_registers
    end

    def read_register(index)
      @registers[index]
    end

    def write_register(index, value)
      @registers[index] = value
    end

    private

    def initialize_registers
      REGISTER_INDEXES.each do |index|
        write_register(index, 0)
      end
    end

    def copy_command_and_data_from_memory_registers
      write_register REGISTER_C0, read_register(REGISTER_M1)
      write_register REGISTER_D0, read_register(REGISTER_M2)
      write_register REGISTER_D1, read_register(REGISTER_M3)
    end
  end
end