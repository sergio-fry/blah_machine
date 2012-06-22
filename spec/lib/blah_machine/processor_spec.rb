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
    end

    describe "#read_register" do
      it "should return value of register" do
        @processor.write_register(Processor::REGISTER_C0, 2)
        @processor.read_register(Processor::REGISTER_C0).should eq(2)
      end
    end

    describe "#next_cycle" do
      it "should copy command and data from memory registers" do
        @processor.write_register(Processor::REGISTER_M1, 1)
        @processor.write_register(Processor::REGISTER_M2, 2)
        @processor.write_register(Processor::REGISTER_M3, 3)

        @processor.next_cycle

        @processor.read_register(Processor::REGISTER_C0).should eq(1)
        @processor.read_register(Processor::REGISTER_D0).should eq(2)
        @processor.read_register(Processor::REGISTER_D1).should eq(3)
      end

      it "should excute current command"
      it "should update pointer to next xommand"
    end

    describe "instruction" do
      describe "SUM" do
        it "should write result to R0" do
          @processor.write_register(Processor::REGISTER_C0, Processor::SUM)
          @processor.write_register(Processor::REGISTER_D0, 4)
          @processor.write_register(Processor::REGISTER_D1, 3)

          @processor.execute_current_instruction

          @processor.read_register(Processor::REGISTER_R0).should eq(7)
        end
      end
    end
  end
end
