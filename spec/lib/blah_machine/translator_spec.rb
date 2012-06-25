require 'spec_helper.rb'

module BlahMachine
  describe Translator do
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
        Translator.translate(source_code).map{|w| w.value}.should eq(machine_code)
      end
    end

    it "should translate SUM program to machine code" do
      source_code = <<SOURCE
      WRITE 9, X0
      JUMP X0
      34 65 0
      WRITE 6, X0
      READ_MEM X0, X1
      WRITE 7, X0
      READ_MEM X0, X2
      SUM X1, X2
      WRITE 8, X0
      WRITE_MEM X0, R0
      WRITE 33, X0
      JUMP X0
SOURCE

      machine_code = [
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

      Translator.translate(source_code).map { |w| w.value }.should eq(machine_code.map { |w| w.value })
    end
  end
end
