require 'spec_helper.rb'

module BlahMachine
  describe MachineWord do
    it "should not be possible to write negative value" do
      lambda do
        MachineWord.new(-1)
      end.should raise_error(MachineWord::ValueIsOutOfRange)
    end

    it "should not be possible to write large value" do
      lambda do
        MachineWord.new(64.kilobytes)
      end.should raise_error(MachineWord::ValueIsOutOfRange)
    end

    describe "#value" do
      it "should return value of word" do
        MachineWord.new(10).value.should eq(10)
      end
    end
  end
end

