# Instructions list
#
# write value to register:
# WRITE regname, value
#
# sum register D0 and D1 and write result to R0
# SUM
#
# jump to position in memory
# JUMP @position
#
# jump to position if register has value 0
# JUMPX @position, register
#
# read memory byte
# READ_MEM addr, register
processor = Processor.new

# calculate sum of 2 integers and write result to R0
# SUM
processor.run_program <<PROGRAM
WRITE D0, 1  
WRITE D1, 2  
SUM
PROGRAM

# calculate mult of 2 integers and write result to MEM(9)
processor.run_program <<PROGRAM
JUMP @cycle
3
2
0 # result here
@cycle
READ_MEM 6, D0
JUMPX @end, D0
READ_MEM 3, D1
READ_MEM 9, D2
SUM
READ_MEM 9, D0
JUMP @cycle
@end
PROGRAM
