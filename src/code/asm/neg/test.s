# Negate
# Format:
#	NEG RD, RS
# Description:
#	对 RS 的内容进行算术否定，结果放在 RD 中。
#   NEG 是一个伪指令，其组合方式相同：SUB RD, x0, RS

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 1		# x6 = 1
	neg x5, x6		# x5 = -x6
	sub x5, x0, x6		# these two instructions assemble into the same thing!

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
