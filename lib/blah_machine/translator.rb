module BlahMachine
  class Translator

    class AssemblerProgram
      def initialize(source_code)
        @source_code = source_code
      end

      def compile
        split_lines
        replace_instructions_by_code
        @lines.flatten.map { |w| MachineWord.new(w) }
      end

      private

      def register_index_by_name(register_name)
        case register_name
        when "X0"
          Processor::REGISTER_X0
        when "X1"
          Processor::REGISTER_X1
        when "X2"
          Processor::REGISTER_X2
        when "R0"
          Processor::REGISTER_R0
        when "D0"
          Processor::REGISTER_D0
        when "D1"
          Processor::REGISTER_D1
        when "C0"
          Processor::REGISTER_C0
        when "M0"
          Processor::REGISTER_M0
        else
          raise "Unknown register name '#{register_name}'"
        end
      end

      def replace_instructions_by_code
        @lines = @lines.map do |line|
          w0, w1, w2 = line.split.map { |w| w.sub(",", "") }

          case w0
          when "COPY"
            [Processor::COPY, register_index_by_name(w1), register_index_by_name(w2)]
          when "JUMP"
            [Processor::JUMP, register_index_by_name(w1), 0]
          when "JUMPX"
            [Processor::JUMPX, register_index_by_name(w1), register_index_by_name(w2)]
          when "READ_MEM"
            [Processor::READ_MEM, register_index_by_name(w1), register_index_by_name(w2)]
          when "SUM"
            [Processor::SUM, register_index_by_name(w1), register_index_by_name(w2)]
          when "WRITE"
            [Processor::WRITE, w1.to_i, register_index_by_name(w2)]
          when "WRITE_MEM"
            [Processor::WRITE_MEM, register_index_by_name(w1), register_index_by_name(w2)]
          else
            [w0, w1, w2].map(&:to_i)
          end
        end
      end

      def split_lines
        @lines = @source_code.split("\n")
      end
    end

    def self.translate(source_code)
      AssemblerProgram.new(source_code).compile
    end
  end
end
