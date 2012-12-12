require 'spec_helper.rb'

module BlahMachine
  describe "sum program" do
    before do
      @machine = Machine.new(32.kilobytes)
    end

    describe "assembler code" do
      before(:each) do
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
      WRITE 0, X0
      JUMP X0
SOURCE

        machine_code = AssemblerProgram.new(source_code).compile

        @machine.memory.data[0..machine_code.size-1] = machine_code
      end

      it "should work" do
        10.times do
          @machine.next_cycle
        end

        @machine.memory.data[8].value.should eq(34 + 65)
      end
    end
  end

  describe "compiled from c lang" do
    before do
      @program = <<PROGRAM
      int main() {
        int a;
        int b;
        a = 2;
        b = 5;

        return a + b;
      }
PROGRAM
      @byte_code = CLangProgram.new(@program).compile
    end

    # Memory struction:
    #
    # R0-1: program loader
    # R2: call stack pointer (points to the first free cell after stack)
    # R3: last procedure return value
    # R4-M: procedures
    # RM+1-N: call stack

    # Procedure stucture
    #


    # Call stack unit structure (inversed relative addresses)
    #
    # R0: return address (Jump)
    # R1-N: variables
    #
    #

    # Procedure call live-cycle
    #
    # * allocate memory in stack
    # * write return address to the R0
    # * write argument variables to stack
    # * procedure writes returned value to the R3 memory register
    # * jump to adrress pointed in R0 stack register

    it "should allocate memory in stack for main function"
    it "should call main function"
  end
end
