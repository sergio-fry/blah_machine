module BlahMachine
  class Machine
    attr_reader :memory, :processor

    def initialize(memory_capacity)
      @processor = Processor.new
      @memory = Memory.new(memory_capacity)
    end

    def next_cycle
      send_instruction_from_proccessor_to_memory
      write_next_intruction_to_processor
      processor.next_cycle
    end

    private

    def send_instruction_from_proccessor_to_memory
      memory.write_register(Memory::REGISTER_C0,
                            processor.read_register(Processor::REGISTER_M4))

      memory.write_register(Memory::REGISTER_D0,
                            processor.read_register(Processor::REGISTER_M5))

      memory.write_register(Memory::REGISTER_D1,
                            processor.read_register(Processor::REGISTER_M6))

      memory.next_cycle

      processor.write_register(Processor::REGISTER_M5, memory.read_register(Memory::REGISTER_D1))
    end

    def write_next_intruction_to_processor
      w1, w2, w3 =
        read_memory(processor.read_register(Processor::REGISTER_M0)),
        read_memory(processor.read_register(Processor::REGISTER_M0) + 1), 
        read_memory(processor.read_register(Processor::REGISTER_M0) + 2)

      processor.write_register(Processor::REGISTER_C0, w1)
      processor.write_register(Processor::REGISTER_D0, w2)
      processor.write_register(Processor::REGISTER_D1, w3)
    end

    def read_memory(address)
      memory.write_register(Memory::REGISTER_C0, Memory::READ)
      memory.write_register(Memory::REGISTER_D0, address)
      memory.next_cycle

      memory.read_register(Memory::REGISTER_D1)
    end
  end
end
