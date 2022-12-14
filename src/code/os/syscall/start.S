#include "platform.h"

	#每个 hart 的堆栈大小为 1024 bytes
	.equ	STACK_SIZE, 1024

	.global	_start

	.text
_start:
	# park harts with id != 0
	csrr	t0, mhartid		# read current hart id
	mv	tp, t0			# keep CPU's hartid in its tp for later usage.
	bnez	t0, park		# if we're not on the hart 0
					# we park the hart

	# 将 BSS 部分中的所有字节设置为零。
	la	a0, _bss_start
	la	a1, _bss_end
	bgeu	a0, a1, 2f
1:
	sw	zero, (a0)
	addi	a0, a0, 4
	bltu	a0, a1, 1b
2:
	# 设置栈，栈是从下往上增长的，所以我们把栈指针放到栈范围的最末端。
	slli	t0, t0, 10		# shift left the hart id by 1024
	la	sp, stacks + STACK_SIZE	# set the initial stack pointer
					# to the end of the first stack space
	add	sp, sp, t0		# move the current hart stack pointer
					# to its place in the stack space

#ifdef CONFIG_SYSCALL
	# https://lore.kernel.org/qemu-devel/20201223192553.332508-1-atish.patra@wdc.com/
	# 对于 qemu 版本 >= 6.0，如果未配置 PMP 实体，则会引发异常。所以只需配置一个 entny，它允许整个 32 位物理地址范围都是 RWX。
	# FIXME: I say it is a temporary workaroud due to I think the patch
	# 上面包含错误，我已经向 qemu 提出了新问题，但直到现在还没有根本原因。详情请参考
	# https://gitlab.com/qemu-project/qemu/-/issues/585 or
	# https://gitee.com/unicornx/riscv-operating-system-mooc/issues/I441IC (in chinese)
	# 因此，到目前为止，尝试更新的 qemu (>= 6.0) 只是一个临时的解决方法。
	li      t0, 0xffffffff
	csrw    pmpaddr0, t0
	li      t0, 0xf
	csrw    pmpcfg0, t0
#endif

	# 在start_kernel结束时，schedule()会调用MRET切换到第一个任务，所以我们这里去掉mstatus。注意：默认 mstatus 为 0
#ifdef CONFIG_SYSCALL
	# 保持 mstatus.MPP 为 0，这样我们将在 MRET 之后以用户模式运行。将 mstatus.MPIE 设置为 1，因此 MRET 将启用中断。
	li	t0, 1 << 7
#else
	# 将 mstatus.MPP 设置为 3，所以我们在 MRET 之后仍然在机器模式下运行。将 mstatus.MPIE 设置为 1，因此 MRET 将启用中断。
	li	t0, 3 << 11 | 1 << 7
#endif
	csrr	a1, mstatus
	or	t0, t0, a1
	csrw	mstatus, t0

	j	start_kernel		# hart 0 jump to c

park:
	wfi
	j	park

stacks:
	.skip	STACK_SIZE * MAXNUM_CPU # allocate space for all the harts stacks

	.end				# End of file
                                             
