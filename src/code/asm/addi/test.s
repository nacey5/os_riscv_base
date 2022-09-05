# Add Immediate
# Format:
#	ADDI RD, RS1, IMM
# Description:
#	立即数（符号扩展的 12 位值，即 -2,048 .. +2,047）被添加到 RS1 的内容中，结果放在 RD 中。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 2		# x6 = 2
	addi x5, x6, 1		# x5 = x6 + 1

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
