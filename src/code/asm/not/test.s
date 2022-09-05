# Not
# Format:
#	NOT RD, RS
# 获取 RS 的内容并翻转每个位。结果值被复制到 RD 中。
# NEG 是一个伪指令，其组合方式相同： XORI RD, RS, -1 注意 -1 是 0xFFFFFFFF

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 0xffff0000	# x6 = 0xffff0000

	not x5, x6		# x5 = ~x6
	xori x5, x6, -1		# the same as not
stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
