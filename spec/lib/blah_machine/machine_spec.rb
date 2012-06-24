require 'spec_helper.rb'

module BlahMachine
  describe Machine do
    context "after initialize" do
      before(:each) do
        @machine = Machine.new(32.kilobytes)

        # infinit loop
        @machine.processor.write_register(Processor::REGISTER_M0, 0)
        @machine.memory.data[0] = MachineWord.new(Processor::JUMP)
        @machine.memory.data[1] = MachineWord.new(0)
      end

      it "should initialize memory" do
        @machine.memory.should be_present
      end

      it "should initialize processor" do
        @machine.processor.should be_present
      end

      it "should initialize instruction pointer of process" do
        @machine.processor.read_register(Processor::REGISTER_M0).should eq(0)
      end

      describe "#next_cycle" do
        it "should execute processor.next_cycle" do
          @machine.processor.should_receive(:next_cycle)

          @machine.next_cycle
        end

        it "should write next instruction to the processor" do
          # set next instruction pointer
          @machine.processor.write_register(Processor::REGISTER_M0, 3)

          # write instruction to memory
          @machine.memory.data[3] = MachineWord.new(Processor::SUM)
          @machine.memory.data[4] = MachineWord.new(Processor::REGISTER_X0)
          @machine.memory.data[5] = MachineWord.new(Processor::REGISTER_X1)

          @machine.next_cycle

          @machine.processor.read_register(Processor::REGISTER_C0).should eq(Processor::SUM)
          @machine.processor.read_register(Processor::REGISTER_D0).should eq(Processor::REGISTER_X0)
          @machine.processor.read_register(Processor::REGISTER_D1).should eq(Processor::REGISTER_X1)
        end

        context "processor send READ instruction to MEM" do
          before(:each) do
            @machine.memory.data[7] = MachineWord.new(87)

            # emulate READ sygnal from processor
            @machine.processor.write_register(Processor::REGISTER_M4, Memory::READ)
            @machine.processor.write_register(Processor::REGISTER_M5, 7)
            @machine.processor.write_register(Processor::REGISTER_M6, Processor::REGISTER_X0)
          end

          it "should send value from memory to processor" do
            @machine.next_cycle
            @machine.processor.read_register(Processor::REGISTER_M5).should eq(87)
          end
        end
      end
    end
  end
end
