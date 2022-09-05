# And
# Format:
#	AND RD, RS1, RS2
# RS1 的内容与 RS2 的内容进行逻辑与运算，结果存放在 RD 中。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 0x10		# x6 = b0001-0000
	li x7, 0x11		# x7 = b0001-0001
	and x5, x6, x7		# x5 = x6 & x7

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
