require 'spec_helper.rb'

module BlahMachine
  describe Processor do
    def write_instruction(processor, instruction, argument1=nil, argument2=nil)
      processor.write_register(Processor::REGISTER_C0, instruction)
      processor.write_register(Processor::REGISTER_D0, argument1) if argument1.present?
      processor.write_register(Processor::REGISTER_D1, argument2) if argument2.present?
    end

    before(:each) do
      @processor = Processor.new
    end

    describe "registers" do
      it "should be hash" do
        @processor.registers.class.should eq(Hash)
      end

      context "just after start" do
        before(:each) do
          @processor = Processor.new
        end
        
        it "should be zero-filled" do
          @processor.registers[Processor::REGISTER_C0].value.should eq(0)
        end
      end
    end

    describe "#write_register" do
      it "should write value to register" do
        @processor.write_register(Processor::REGISTER_C0, 1)
        @processor.registers[Processor::REGISTER_C0].value.should eq(1)
      end

      it "should raise error if trying to access undefined register" do
        lambda do
          @processor.write_register(123, 1)
        end.should raise_error(Processor::UndefinedRegister)
      end
    end

    describe "#read_register" do
      it "should return value of register" do
        @processor.write_register(Processor::REGISTER_C0, 2)
        @processor.read_register(Processor::REGISTER_C0).should eq(2)
      end

      it "should raise error if trying to access undefined register" do
        lambda do
          @processor.read_register(123)
        end.should raise_error(Processor::UndefinedRegister)
      end
    end

    describe "#next_cycle" do
      it "should write idle command to M4" do
        write_instruction(@processor, Processor::READ_MEM, 10, Processor::REGISTER_X0)
        @processor.next_cycle

        write_instruction(@processor, Processor::SUM, Processor::REGISTER_X0, Processor::REGISTER_X1)
        @processor.next_cycle

        @processor.read_register(Processor::REGISTER_M4).should eq(Memory::IDLE)
      end

      it "should update pointer to next xommand"
    end

    describe "instruction" do
      describe "SUM" do
        it "should write result to R0" do
          @processor.write_register(Processor::REGISTER_X0, 4)
          @processor.write_register(Processor::REGISTER_X1, 3)
          write_instruction(@processor, Processor::SUM, Processor::REGISTER_X0, Processor::REGISTER_X1)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_R0).should eq(7)
        end
      end

      describe "COPY" do
        it "should write value to specified register" do
          @processor.write_register(Processor::REGISTER_X0, 4)
          write_instruction(@processor, Processor::COPY, Processor::REGISTER_X0, Processor::REGISTER_M0)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M0).should eq(4)
        end
      end

      describe "JUMP" do
        it "should update M0" do
          @processor.write_register(Processor::REGISTER_X0, 33)
          write_instruction(@processor, Processor::JUMP, Processor::REGISTER_X0)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M0).should eq(33)
        end
      end

      describe "JUMPX" do
        it "should update M0 if X1 == 0" do
          @processor.write_register(Processor::REGISTER_M0, 0)
          @processor.write_register(Processor::REGISTER_X0, 31)
          @processor.write_register(Processor::REGISTER_X1, 0)

          write_instruction(@processor, Processor::JUMPX, Processor::REGISTER_X0, Processor::REGISTER_X1)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M0).should eq(31)
        end

        it "should not update M0 if X1 != 0" do
          @processor.write_register(Processor::REGISTER_M0, 0)
          @processor.write_register(Processor::REGISTER_X0, 31)
          @processor.write_register(Processor::REGISTER_X1, 1)

          write_instruction(@processor, Processor::JUMPX, Processor::REGISTER_X0, Processor::REGISTER_X1)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M0).should eq(0)
        end
      end

      describe "READ_MEM" do
        it "should write READ instruction to M4-M6" do
          @processor.write_register(Processor::REGISTER_X0, 64)
          write_instruction(@processor, Processor::READ_MEM, Processor::REGISTER_X0, Processor::REGISTER_X1)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M4).should eq(Memory::READ)
          @processor.read_register(Processor::REGISTER_M5).should eq(64)
          @processor.read_register(Processor::REGISTER_M6).should eq(Processor::REGISTER_X1)
        end

        it "should copy value from MEM to defined register" do
          @processor.write_register(Processor::REGISTER_X0, 64)
          write_instruction(@processor, Processor::READ_MEM, Processor::REGISTER_X0, Processor::REGISTER_X1)

          @processor.next_cycle

          # data read from MEM
          @processor.write_register(Processor::REGISTER_M5, 47)
          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_X1).should eq(47)
        end
      end

      describe "WRITE_MEM" do
        it "should write WRITE instruction to M4-M6" do
          @processor.write_register(Processor::REGISTER_X0, 63)
          @processor.write_register(Processor::REGISTER_X1, 65)
          write_instruction(@processor, Processor::WRITE_MEM, Processor::REGISTER_X0, Processor::REGISTER_X1)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M4).should eq(Memory::WRITE)
          @processor.read_register(Processor::REGISTER_M5).should eq(63)
          @processor.read_register(Processor::REGISTER_M6).should eq(65)
        end
      end
    end
  end
end
