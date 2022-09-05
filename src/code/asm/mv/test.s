# Move (Register to Register)
# Format:
#	MV RD, RS
# Description:
#	RS 的内容被复制到 RD 中。
#   MV 是伪指令，其组合方式相同：ADDI RD, RS, 0

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 30		# x6 = 30
	mv x5, x6		# x5 = x6
	addi x5, x6, 0		# these two instructions assemble into the same thing!
stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
