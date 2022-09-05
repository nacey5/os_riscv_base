# Branch if Not Equal
# Format:
#	BNE RS1, RS2, IMM
# Description:
#	RS1 的内容与 RS2 的内容进行比较。如果不相等，则控制跳转到与 PC 相关的目标地址。
# Note:
#	编程时，我们只提供标签而不是立即值，让链接器提供最终的立即值。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	# i = 0
	# while (i < 5) i++;

	li x5, 0
	li x6, 5
loop:
	addi x5, x5, 1
	bne x5, x6, loop

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
