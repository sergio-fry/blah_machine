module BlahMachine
  class AssemblerProgram
    JUMP_LABEL_REGEXP = /^@[a-z0-9_]+$/
      def initialize(source_code)
        @source_code = source_code
      end

    def compile
      split_lines
      build_jump_labels_table
      translate_meta_jumps
      replace_instructions_by_code
      @lines.flatten.map { |w| MachineWord.new(w) }
    end

    private

    def build_jump_labels_table
      line_number = 0
      @jump_labels = {}

      @lines.each do |line|
        w0, = line.split

        if w0.match(JUMP_LABEL_REGEXP)
          @jump_labels[w0] = line_number
        end

        line_number = line_number + 1
      end
    end

    def translate_meta_jumps
      @jump_labels.each do |label_name, jump_line_number|
        line_number = 0

        @lines.each do |line|
          instruction, label_name  = line.split
          if instruction == "JUMP" and label_name.match(JUMP_LABEL_REGEXP)
            @lines[line_number..line_number] = [
              "WRITE #{@jump_labels[label_name] * 3 + 3}, M0",
            ]
          end

          line_number = line_number + 1
        end
      end
    end

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
          #if w1.match(/^@[a-z_0-9]+^/) 
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
end
