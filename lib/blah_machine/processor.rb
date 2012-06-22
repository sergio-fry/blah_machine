module BlahMachine
  class Processor
    class UnknownInstruction < StandardError; end;

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

    ###############################################
    # Instructions

    SUM = 100
    JUMP = 110
    JUMPX = 111
    WRITE = 120
    READ_MEM = 130
    WRITE_MEM = 131

    attr_reader :registers

    def initialize
      @registers = {}
      initialize_registers
    end

    # start next processor cycle
    def next_cycle
      pre_cycle
      user_cycle
      after_cycle
    end

    # excute instruction, located in C0
    def execute_current_instruction
      case read_register(REGISTER_C0)
      when SUM
        write_register(REGISTER_R0, read_register(REGISTER_D0) + read_register(REGISTER_D1))
      when WRITE
        write_register(read_register(REGISTER_D1), read_register(REGISTER_D0))
      when JUMP
        write_register(REGISTER_M0, read_register(REGISTER_D0))
      when JUMPX
        write_register(REGISTER_M0, read_register(REGISTER_D0)) if read_register(read_register(REGISTER_D1)) == 0
      when READ_MEM
        write_register(REGISTER_M4, Memory::READ)
        write_register(REGISTER_M5, read_register(REGISTER_D0))
      when WRITE_MEM
        write_register(REGISTER_M4, Memory::WRITE)
        write_register(REGISTER_M5, read_register(REGISTER_D0))
        write_register(REGISTER_M6, read_register(REGISTER_D1))
      else
        raise UnknownInstruction.new("Instruction '#{read_register(REGISTER_C0)}' is undefined")
      end
    end

    def read_register(index)
      @registers[index].value
    end

    def write_register(index, value)
      @registers[index] = MachineWord.new(value)
    end

    private

    # System Pre Cycle. Executed before Users Cycle
    def pre_cycle
      copy_command_and_data_from_memory_registers
      initialize_memory_instruction_registers
    end

    # User Cycle
    def user_cycle
      execute_current_instruction
    end

    # System After Cycle. Executed after Users Cycle
    def after_cycle
    end

    def initialize_memory_instruction_registers
      write_register(REGISTER_M4, Memory::IDLE)
    end

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
