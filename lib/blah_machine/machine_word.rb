module BlahMachine
  class MachineWord
    class ValueIsOutOfRange < StandardError; end;

    MAX_VALUE = 2 ** 16

    attr_reader :value

    def initialize(value)
      if value < 0 || value > MAX_VALUE
        raise ValueIsOutOfRange.new("Value '#{value}' is out of range 0 - #{MAX_VALUE}")
      end

      @value = value
    end
  end
end
