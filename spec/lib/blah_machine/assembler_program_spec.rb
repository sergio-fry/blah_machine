require 'spec_helper.rb'

module BlahMachine
  describe AssemblerProgram do
    { 
      "34 65 0" => [34, 65, 0],
      "COPY X0, X1" => [Processor::COPY, Processor::REGISTER_X0, Processor::REGISTER_X1],
      "JUMP X0" => [Processor::JUMP, Processor::REGISTER_X0, 0],
      "JUMPX X0, R0" => [Processor::JUMPX, Processor::REGISTER_X0, Processor::REGISTER_R0],
      "READ_MEM X0, X1" => [Processor::READ_MEM, Processor::REGISTER_X0, Processor::REGISTER_X1],
      "SUM X0, X1" => [Processor::SUM, Processor::REGISTER_X0, Processor::REGISTER_X1],
      "WRITE 9, X0" => [Processor::WRITE, 9, Processor::REGISTER_X0],
      "WRITE_MEM X0, X1" => [Processor::WRITE_MEM, Processor::REGISTER_X0, Processor::REGISTER_X1],
    }.each do |source_code, machine_code|
      it "should translace source code '#{source_code}' to machine code '#{machine_code.join(", ")}'" do
        AssemblerProgram.new(source_code).compile.map{|w| w.value}.should eq(machine_code)
      end
    end
  end
end
