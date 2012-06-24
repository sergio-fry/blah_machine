require 'spec_helper.rb'

module BlahMachine
  describe "sum program" do
    before(:each) do
      @machine = Machine.new(32.kilobytes)

      program = [
        Processor::WRITE, 9, Processor::REGISTER_X0,
        Processor::JUMP, Processor::REGISTER_X0, 0,
        34, 65, 0,
        Processor::WRITE, 6, Processor::REGISTER_X0,
        Processor::READ_MEM, Processor::REGISTER_X0, Processor::REGISTER_X1,
        Processor::WRITE, 7, Processor::REGISTER_X0,
        Processor::READ_MEM, Processor::REGISTER_X0, Processor::REGISTER_X2,
        Processor::SUM, Processor::REGISTER_X1, Processor::REGISTER_X2,
        Processor::WRITE, 8, Processor::REGISTER_X0,
        Processor::WRITE_MEM, Processor::REGISTER_X0, Processor::REGISTER_R0,
        Processor::WRITE, 33, Processor::REGISTER_X0,
        Processor::JUMP, Processor::REGISTER_X0, 0,
      ].map { |w| MachineWord.new(w) }

      @machine.memory.data[0..program.size-1] = program
    end

    it "should work" do
      10.times do
        @machine.next_cycle
      end

      @machine.memory.data[8].value.should eq(34 + 65)
    end
  end
end
