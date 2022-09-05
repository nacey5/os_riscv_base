# Substract
# Format:
#	SUB RD, RS1, RS2
# Description:
#	从 RS1 的内容中减去 RS2 的内容并将结果放在 RD 中。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, -1		# x6 = -1
	li x7, -2		# x7 = -2
	sub x5, x6, x7		# x5 = x6 - x7

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
