module BlahMachine
  class MachineWord
    class ValueIsOutOfRange < StandardError; end;

    MAX_VALUE = 2 ** 16 - 1

    attr_reader :value

    def initialize(value=nil)
      # write garbage value if not defined
      value = rand(0..MAX_VALUE) if value.nil?

      if value < 0 || value > MAX_VALUE
        raise ValueIsOutOfRange.new("Value '#{value}' is out of range 0 - #{MAX_VALUE}")
      end

      @value = value
    end
  end
end
