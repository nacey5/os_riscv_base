#include "os.h"

void plic_init(void)
{
	int hart = r_tp();

	/*
	 * Set priority for UART0.
	 *
	 * 每个 PLIC 中断源可以通过写入其 32 位内存映射优先级寄存器来分配优先级。
	 * QEMU-virt（与 FU540-C000 相同）支持 7 级优先级。保留优先级值 0 表示“从不中断”并有效地禁用中断。
	 * 优先级 1 是最低的活动优先级，优先级 7 是最高的。相同优先级的全局中断之间的联系被中断 ID 打破；
	 * 具有最低 ID 的中断具有最高的有效优先级。
	 */
	*(uint32_t*)PLIC_PRIORITY(UART0_IRQ) = 1;

	/*
	 * Enable UART0
	 *
	 * 每个全局中断都可以通过设置启用寄存器中的相应位来启用。
	 */
	*(uint32_t*)PLIC_MENABLE(hart)= (1 << UART0_IRQ);

	/*
	 * 设置 UART0 的优先级阈值。 PLIC 将屏蔽所有优先级小于或等于阈值的中断。
	 * 最大阈值为 7。例如，阈值 0 允许所有具有非零优先级的中断，而值 7 则屏蔽所有中断。
	 * 请注意，阈值对于 PLIC 是全局的，而不是针对每个中断源。
	 */
	*(uint32_t*)PLIC_MTHRESHOLD(hart) = 0;

	/* 启用机器模式外部中断。 */
	w_mie(r_mie() | MIE_MEIE);
}

/*
 *描述：查询 PLIC 我们应该服务什么中断。通过读取请求寄存器来执行中断请求，
 *该寄存器返回最高优先级的挂起中断的 ID，如果没有挂起的中断，则返回零。成功的声明还会自动清除中断源上相应的未决位。
 * 返回值：最高优先级的挂起中断的 ID，如果没有挂起的中断，则为零。
 */
int plic_claim(void)
{
	int hart = r_tp();
	int irq = *(uint32_t*)PLIC_MCLAIM(hart);
	return irq;
}

/*
 * DESCRIPTION:
  *	将它从声明 (irq) 接收到的中断 ID 写入完整的寄存器将向 PLIC 发出我们已经为该 IRQ 提供服务的信号。
  *PLIC 不检查完成 ID 是否与该目标的最后一个声明 ID 相同。如果完成 ID 与当前为目标启用的中断源不匹配，则会静默忽略完成。
 * RETURN VALUE: none
 */
void plic_complete(int irq)
{
	int hart = r_tp();
	*(uint32_t*)PLIC_MCOMPLETE(hart) = irq;
}
