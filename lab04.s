
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
    lbu t0,0(a0)
    lbu t1,0(a1)

    
loop:    
    beq t0,zero,return0
    beq t1,zero,return1
    beq t0,t1,skip
    blt t0,t1,return0
    j return1
    
    
skip:
    addi a0,a0,1
    addi a1,a1,1
    lbu t0,0(a0)
    lbu t1,0(a1)
    j loop   
return0:
    add a0,zero,zero
    j end
return1:
    addi a0,zero,1
end:
            jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
    addi sp,sp,-12
    sw ra,8(sp)
    sw a1,4(sp)
    sw a0,0(sp)
    
    slti t0,a1,2
    beq t0,zero,skipReturn
    
    addi a0,zero,1
    addi sp,sp,12
    jr   ra
skipReturn:
    lw a1,0(a0)
    lw a0,4(a0)
    jal ra,str_ge
    bne a0,zero,then
    addi ,a0,zero,0
    addi sp,sp,8
    lw ra,0(sp)
    jr ra
then:
    lw a0,0(sp)
    lw a1,4(sp)
    addi sp,sp,8
    addi a1,a1,-1
    addi a0,a0,4
    jal ra,recCheck
    addi sp,sp,4
    lw ra,0(sp)
    jr ra