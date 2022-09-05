# Add
# Format:
#	ADD RD, RS1, RS2
# Description:
#	RS1 的内容与 RS2 的内容相加，结果存放在 RD 中。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 1		# x6 = 1
	li x7, 2		# x7 = 2
	add x5, x6, x7		# x5 = x6 + x7

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
