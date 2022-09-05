# Shift Right Arithmetic Immediate
# Format:
#	SRAI RD, RS1, IMM
# Description:
# 	立即数确定要移位的位数。 RS1 的内容右移了很多位，结果放在 RD 中。这种移位是“算术的”，即符号位在最高有效端重复移入。
# Comment:
#	In C, for signed integer, >> is shift right with arithmetic.

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
#	li x6, 0x80		# x6 = 0b1000-0000
	li x6, 0x80000000	# x6 = 0b1000-0000-0000-0000-0000-0000-0000-0000
	srai x5, x6, 4		# x5 = x6 >> 4

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
