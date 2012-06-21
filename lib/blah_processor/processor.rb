module BlahMachine
  class Processor
    ###############################################
    # Registers inxedes

    # Command
    REGISTER_C0 = 0

    # Data
    REGISTER_D0 = 10
    REGISTER_D1 = 11

    # Result
    REGISTER_R0 = 20

    # RAM
    REGISTER_M0 = 30 # pointer to next command
    REGISTER_M1 = 31 # command
    REGISTER_M2 = 32 # data
    REGISTER_M3 = 33 # data
  end
end
