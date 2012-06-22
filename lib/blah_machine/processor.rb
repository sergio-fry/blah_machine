module BlahMachine
  class Processor
    class UnknownInstruction < StandardError; end;
    include ProcessorRegisters
    include ProcessorInstructions

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

    private

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
