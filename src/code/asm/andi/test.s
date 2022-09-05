# And Immediate
# Format:
#	ANDI RD, RS1, IMM
# Description:
#	立即数（符号扩展的 12 位值，即 -2,048 .. +2,047）与 RD1 的内容进行逻辑与运算，结果放在 RD 中。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 0x10		# x6 = b1000-0000
	andi x5, x6, 0x01	# x5 = x6 & 0x01

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
