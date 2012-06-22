require 'spec_helper.rb'

module BlahMachine
  describe Processor do
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
      it "should copy command and data from memory registers" do
        @processor.write_register(Processor::REGISTER_M1, Processor::SUM)
        @processor.write_register(Processor::REGISTER_M2, 2)
        @processor.write_register(Processor::REGISTER_M3, 3)

        @processor.next_cycle

        @processor.read_register(Processor::REGISTER_C0).should eq(Processor::SUM)
        @processor.read_register(Processor::REGISTER_D0).should eq(2)
        @processor.read_register(Processor::REGISTER_D1).should eq(3)
      end

      it "should write idle command to M1" do
        @processor.write_register(Processor::REGISTER_M1, Processor::SUM)
        @processor.write_register(Processor::REGISTER_M2, 2)
        @processor.write_register(Processor::REGISTER_M3, 3)
        @processor.write_register(Processor::REGISTER_M4, 1)

        @processor.next_cycle

        @processor.read_register(Processor::REGISTER_M4).should eq(Memory::IDLE)
      end

      it "should update pointer to next xommand"
    end

    describe "instruction" do
      describe "SUM" do
        it "should write result to R0" do
          @processor.write_register(Processor::REGISTER_M1, Processor::SUM)
          @processor.write_register(Processor::REGISTER_M2, 4)
          @processor.write_register(Processor::REGISTER_M3, 3)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_R0).should eq(7)
        end
      end

      describe "WRITE" do
        it "should write value to specified register" do
          @processor.write_register(Processor::REGISTER_M1, Processor::WRITE)
          @processor.write_register(Processor::REGISTER_M2, 4)
          @processor.write_register(Processor::REGISTER_M3, Processor::REGISTER_M0)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M0).should eq(4)
        end
      end

      describe "JUMP" do
        it "should update M0" do
          @processor.write_register(Processor::REGISTER_M1, Processor::JUMP)
          @processor.write_register(Processor::REGISTER_M2, 33)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M0).should eq(33)
        end
      end

      describe "JUMPX" do
        context "REGISTER_R0 is 0" do
          before(:each) do
            @processor.write_register(Processor::REGISTER_R0, 0)
          end

          it "should update M0" do
            @processor.write_register(Processor::REGISTER_M0, 0)

            @processor.write_register(Processor::REGISTER_M1, Processor::JUMPX)
            @processor.write_register(Processor::REGISTER_M2, 31)
            @processor.write_register(Processor::REGISTER_M3, Processor::REGISTER_R0)

            @processor.next_cycle

            @processor.read_register(Processor::REGISTER_M0).should eq(31)
          end
        end

        context "REGISTER_R0 is 1" do
          before(:each) do
            @processor.write_register(Processor::REGISTER_R0, 1)
          end

          it "should update M0" do
            @processor.write_register(Processor::REGISTER_M0, 0)

            @processor.write_register(Processor::REGISTER_M1, Processor::JUMPX)
            @processor.write_register(Processor::REGISTER_M2, 31)
            @processor.write_register(Processor::REGISTER_M3, Processor::REGISTER_R0)

            @processor.next_cycle

            @processor.read_register(Processor::REGISTER_M0).should eq(0)
          end
        end
      end

      describe "READ_MEM" do
        it "should write READ instruction to M4-M6" do
          @processor.write_register(Processor::REGISTER_M1, Processor::READ_MEM)
          @processor.write_register(Processor::REGISTER_M2, 64)
          @processor.write_register(Processor::REGISTER_M3, Processor::REGISTER_X0)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M4).should eq(Memory::READ)
          @processor.read_register(Processor::REGISTER_M5).should eq(64)
          @processor.read_register(Processor::REGISTER_M6).should eq(Processor::REGISTER_X0)
        end

        it "should copy value from MEM to defined register" do
          @processor.write_register(Processor::REGISTER_M1, Processor::READ_MEM)
          @processor.write_register(Processor::REGISTER_M2, 64)
          @processor.write_register(Processor::REGISTER_M3, Processor::REGISTER_X0)

          @processor.next_cycle

          # data read from MEM
          @processor.write_register(Processor::REGISTER_M5, 47)
          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_X0).should eq(47)
        end
      end

      describe "WRITE_MEM" do
        it "should write READ instruction to M4-M6" do
          @processor.write_register(Processor::REGISTER_M1, Processor::WRITE_MEM)
          @processor.write_register(Processor::REGISTER_M2, 63)
          @processor.write_register(Processor::REGISTER_M3, 65)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M4).should eq(Memory::WRITE)
          @processor.read_register(Processor::REGISTER_M5).should eq(63)
          @processor.read_register(Processor::REGISTER_M6).should eq(65)
        end
      end

      describe "READ_MEM" do
        it "should write READ instruction to M4-M6" do
          @processor.write_register(Processor::REGISTER_M1, Processor::READ_MEM)
          @processor.write_register(Processor::REGISTER_M2, 64)

          @processor.next_cycle

          @processor.read_register(Processor::REGISTER_M4).should eq(Memory::READ)
          @processor.read_register(Processor::REGISTER_M5).should eq(64)
        end
      end
    end
  end
end
