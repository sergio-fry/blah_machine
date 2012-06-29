require 'spec_helper.rb'

module BlahMachine
  describe Memory do
    before(:each) do
      @memory = Memory.new(32.kilobytes)
    end

    it "should be possible to define memory size" do
      memory = Memory.new(32.kilobytes)
      memory.capacity.should eq(32.kilobytes)
    end

    describe "WRITE" do
      it "should be possible to write cell" do
        @memory.write_register(Memory::REGISTER_C0, Memory::WRITE)
        @memory.write_register(Memory::REGISTER_D0, 0)
        @memory.write_register(Memory::REGISTER_D1, 12)

        @memory.next_cycle

        @memory.data[0].value.should eq(12)
        @memory.read_register(Memory::REGISTER_S0).should eq(Memory::STATUS_OK)
      end

      it "should be possible to write cell" do
        @memory.write_register(Memory::REGISTER_C0, Memory::WRITE)
        @memory.write_register(Memory::REGISTER_D0, 32.kilobytes + 1)
        @memory.write_register(Memory::REGISTER_D1, 12)

        @memory.next_cycle

        @memory.read_register(Memory::REGISTER_S0).should eq(Memory::STATUS_OK)
      end
    end

    describe "READ" do
      it "should be possible to read cell" do
        @memory.data[10] = MachineWord.new(76)

        @memory.write_register(Memory::REGISTER_C0, Memory::READ)
        @memory.write_register(Memory::REGISTER_D0, 10)

        @memory.next_cycle

        @memory.read_register(Memory::REGISTER_D1).should eq(76)
        @memory.read_register(Memory::REGISTER_S0).should eq(Memory::STATUS_OK)
      end

      it "should return error status if address is out of range" do
        @memory.write_register(Memory::REGISTER_C0, Memory::READ)
        @memory.write_register(Memory::REGISTER_D0, 32.kilobytes + 1)

        @memory.next_cycle

        @memory.read_register(Memory::REGISTER_S0).should eq(Memory::STATUS_ADDRESS_IS_OUT_OF_RANGE)
      end
    end
  end
end
