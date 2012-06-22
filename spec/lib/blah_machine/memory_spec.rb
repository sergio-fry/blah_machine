require 'spec_helper.rb'

module BlahMachine
  describe Memory do
    before(:each) do
      @memory = Memory.new(64.kilobytes)
    end

    it "should be possible to define memory size" do
      memory = Memory.new(64.kilobytes)
      memory.capacity.should eq(64.kilobytes)
    end

    it "should be possible to write cell" do
      @memory.write(0, 1)
      @memory.read(0).should eq(1)
    end

    it "should not be possible use negative address" do
      lambda do
        @memory.write(-1, 1)
      end.should raise_error(Memory::AddressIsOutOfRange)
    end

    it "should not be possible use address out of capacity" do
      @memory = Memory.new(64.kilobytes)
      lambda do
        @memory.write(64.kilobytes, 1)
      end.should raise_error(Memory::AddressIsOutOfRange)
    end
  end
end
