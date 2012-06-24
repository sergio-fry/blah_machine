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

    end

    def write_next_intruction_to_processor
      processor.write_register(Processor::REGISTER_C0, memory.read(processor.read_register(Processor::REGISTER_M0)))
      processor.write_register(Processor::REGISTER_D0, memory.read(processor.read_register(Processor::REGISTER_M0) + 1))
      processor.write_register(Processor::REGISTER_D1, memory.read(processor.read_register(Processor::REGISTER_M0) + 2))
    end
  end
end
