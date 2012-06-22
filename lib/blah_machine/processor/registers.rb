module BlahMachine
  module ProcessorRegisters
    extend ActiveSupport::Concern

    attr_reader :registers

    # Command
    REGISTER_C0 = 0

    # Data
    REGISTER_D0 = 10
    REGISTER_D1 = 11

    # Result
    REGISTER_R0 = 20

    # RAM
    #
    # Every cycle next command and its arguments
    # are loaded to M1-M3 registers from RAM.
    #
    REGISTER_M0 = 30 # pointer to next command
    REGISTER_M1 = 31 # command
    REGISTER_M2 = 32 # data
    REGISTER_M3 = 33 # data

    # command for memory module
    REGISTER_M4 = 34 # memory command
    REGISTER_M5 = 35 # data
    REGISTER_M6 = 36 # data

    REGISTER_INDEXES = [
      REGISTER_C0,
      REGISTER_D0,
      REGISTER_D1,
      REGISTER_R0,
      REGISTER_M0,
      REGISTER_M1,
      REGISTER_M2,
      REGISTER_M3,
      REGISTER_M4,
      REGISTER_M5,
      REGISTER_M6
    ]

    def read_register(index)
      @registers[index].value
    end

    def write_register(index, value)
      @registers[index] = MachineWord.new(value)
    end
  end
end