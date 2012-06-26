module BlahMachine
  # Blah variant of C Lang
  class CLangProgram
    def initialize(source_code)
      @source_code = source_code
    end

    # compile to Blah Assembler
    def compile
      @source_code
    end
  end
end
