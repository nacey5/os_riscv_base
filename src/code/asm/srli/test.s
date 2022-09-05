# Shift Right Logical Immediate
# Format:
#	SRLI RD, RS1, IMM
# Description:
#	立即数确定要移位的位数。 RS1 的内容右移了很多位，结果放在 RD 中。
#   在最高有效端移入的位用零填充。对于 32 位机器，移位量必须在 0..31 以内，0 表示不进行移位。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 0x80000000	# x6 = 0x80000000
	srli x5, x6, 3		# x5 = x6 >> 3

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
