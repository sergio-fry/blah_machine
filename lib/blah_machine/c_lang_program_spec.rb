require 'spec_helper.rb'

module BlahMachine
  describe CLangProgram do
    it "should compile empty program" do
      source_code =<<SOURCE
void main() {
  return;
}
SOURCE
      CLangProgram.new(source_code).compile.should eq(<<ASSEMBLER
@start

JUMP @main
@main
JUMP @start
ASSEMBLER
    end

    it "should compile sum program" do
      source_code =<<SOURCE
int main() {
  return 4 + 6;
}
SOURCE
      CLangProgram.new(source_code).compile.should eq(<<ASSEMBLER
@start
JUMP @main

@main
WRITE 4, X0
WRITE 6, X1
SUM X0, X1
WRITE 6, X0
WRITE_MEM X0, R0
JUMP @start
ASSEMBLER
    end
  end
end
