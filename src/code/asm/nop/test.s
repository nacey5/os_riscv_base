# Nop
# Format:
#	NOP
# Description:
#	该指令无效。 NOP 是一个伪指令，其组装方式与：ADDI x0, x0, 0 相同

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	nop			# do nothing and has no effect on system

	addi x0, x0, 0		# the same as nop

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
