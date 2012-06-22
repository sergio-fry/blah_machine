module BlahMachine
  module ProcessorInstructions
    ###############################################
    # Instructions
    #
    # sum X0 and X1:
    #   SUM X0, X1
    # 
    # jump to address writen in X0
    #   JUMP X0
    #
    # jump to address writen in X0 if X1 == 0
    #   JUMPX X0, X1
    #
    # copy rexister X0 to X1
    #   COPY X0, X1
    # 
    # read value from address written in X0 to X1
    #   READ_MEM X0, X1
    #
    # write value from register X0 to address written in X1
    #   WRITE_MEM X0, X1

    SUM = 100
    JUMP = 110
    JUMPX = 111
    COPY = 120
    READ_MEM = 130
    WRITE_MEM = 131
  end
end
