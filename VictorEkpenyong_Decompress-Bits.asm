# Victor Ekpenyong
# Assembly Language
# Decompress Bits
	.data

chars:    .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ .,!-'"

msg1:     .word 0x93EA9646, 0xCDE50442, 0x34D29306, 0xD1F33720

          .word 0x56033D01, 0x394D963B, 0xDE7BEFA4  

msg1end:

	.text
	
#Initialization

#nextbyte assigned to $a1 register
la $a1, msg1 #nextbyte

#end of message assigned to $s2 register
la $s2, msg1end

#chars values assigned to $s1 register
la $s1, chars

#bits & buffer set to 0 to start
la $a2, 0 #bits
la $a3, 0 #buffer

#Start of while loop, jumps to conditional statement
j whileCheck


while:

#If statment; if bits is greater than or equal to 5 if statement fails
bge $a2, 5, outsideIf

#loads first byte of message into $t1 (temp1)
lbu $t1, 0($a1)
#increments nextbyte to next value
addiu $a1, $a1, 1
#shifts buffer to the left by 8
sll $a3, $a3, 8
#or's value of buffer and current byte
or $a3, $a3, $t1
#adds 8 to bits
add $a2,$a2, 8


outsideIf:
#subtracts 5 from bits
add $a2, $a2, -5
#temp2 set equal to buffer shifted to the right number of current bit value
srlv $t2, $a3, $a2
#ands temp2 and 1F (....0011111)
and $t2, $t2, 0x1F

#add temp2 value and chars value to get needed ascii value
add $t2, $t2, $s1
#value printed
li $v0, 11
lbu $a0, 0($t2)
syscall

#while loop conditonal statement
whileCheck:
blt $a1, $s2, while


#program ends
li $v0, 10
syscall


