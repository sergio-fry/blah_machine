# BlahMachine

Dummy machine emulator

## Installation

Add this line to your application's Gemfile:

    gem 'blah_processor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blah_processor

## Usage

      @machine = Machine.new(32.kilobytes)

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

      10.times do
        @machine.next_cycle
      end

      @machine.memory.data[8].value.should eq(34 + 65)

## TODO
* C Compiler: function call


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
