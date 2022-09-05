#include "os.h"

/*
 * UART 控制寄存器映射到地址 UART0。该宏返回其中一个寄存器的地址。
 */
#define UART_REG(reg) ((volatile uint8_t *)(UART0 + reg))

/*
 * Reference
 * [1]: TECHNICAL DATA ON 16550, http://byterunner.com/16550.html
 */

/*
 * 0 (write mode): THR/DLL
 * 1 (write mode): IER/DLM
 */
#define RHR 0	// 接收保持寄存器（读取模式）(read mode)
#define THR 0	// 发送保持寄存器(write mode)
#define DLL 0	// 除数锁存器的 LSB (write mode)
#define IER 1	// 中断使能寄存器 (write mode)
#define DLM 1	// 除数锁存器的 MSB (write mode)
#define FCR 2	// 先进先出控制寄存器 (write mode)
#define ISR 2	// 中断状态寄存器 (read mode)
#define LCR 3	// 线路控制寄存器
#define MCR 4	// 调制解调器控制寄存器
#define LSR 5	// 线路状态寄存器
#define MSR 6	// 调制解调器状态寄存器
#define SPR 7	// ScratchPad 寄存器

/*
 * POWER UP DEFAULTS
 * IER = 0: TXRX 保持寄存器中断均被禁用
 * ISR = 1: 没有中断
 * LCR = 0
 * MCR = 0
 * LSR = 60 HEX
 * MSR = BITS 0-3 = 0, BITS 4-7 = inputs
 * FCR = 0
 * TX = High
 * OP1 = High
 * OP2 = High
 * RTS = High
 * DTR = High
 * RXRDY = High
 * TXRDY = Low
 * INT = Low
 */

/*
 * LINE STATUS REGISTER (LSR)
 * LSR BIT 0:
 * 0 = 接收保持寄存器或 FIFO 中没有数据。 1 = 数据已接收并保存在接收保持寄存器或 FIFO 中。
 * ......
 * LSR BIT 5:
 * 0 = 发送保持寄存器已满。 16550 将不接受任何数据进行传输。 1 = 发送器保持寄存器（或 FIFO）为空。 CPU 可以加载下一个字符。
 * ......
 */
#define LSR_RX_READY (1 << 0)
#define LSR_TX_IDLE  (1 << 5)

#define uart_read_reg(reg) (*(UART_REG(reg)))
#define uart_write_reg(reg, v) (*(UART_REG(reg)) = (v))

void uart_init()
{
	/* 禁用中断。 */
	uart_write_reg(IER, 0x00);

	/*
	 * 设置波特率。 如果我们关心除数，这里只是一个演示，
     *  但是对于我们的目的 [QEMU-virt]，这并没有真正做任何事情。
	 *
	 * 请注意，除数寄存器 DLL（除数锁存器最少）和 DLM（除数
	 * 锁存器大多数）具有与接收器/发送器相同的基地址和
	 * 中断使能寄存器。 为了改变基地址指向的内容，我们
	 * 通过将 1 写入除数锁存访问位来打开“除数锁存器”
	 * (DLAB)，即行控制寄存器 (LCR) 的位索引 7。
	 *
	 *  关于波特率值，请参见[1]“波特率发生器编程表”。
	 *  我们在1.8432MHZ晶振时使用38.4K，所以对应的值为3。
	 *  并且由于除数寄存器是两个字节（16位），所以我们需要
	 *  将 3(0x0003) 的值拆分为两个字节，DLL 存储低字节，
	 *  DLM 存储高字节。
	 */
	uint8_t lcr = uart_read_reg(LCR);
	uart_write_reg(LCR, lcr | (1 << 7));
	uart_write_reg(DLL, 0x03);
	uart_write_reg(DLM, 0x00);

	/*
	 * Continue setting the asynchronous data communication format.
	 * - number of the word length: 8 bits
	 * - number of stop bits：1 bit when word length is 8 bits
	 * - no parity
	 * - no break control
	 * - disabled baud latch
	 */
	lcr = 0;
	uart_write_reg(LCR, lcr | (3 << 0));

	/*
	 *启用接收中断。
	 */
	uint8_t ier = uart_read_reg(IER);
	uart_write_reg(IER, ier | (1 << 0));
}

int uart_putc(char ch)
{
	while ((uart_read_reg(LSR) & LSR_TX_IDLE) == 0);
	return uart_write_reg(THR, ch);
}

void uart_puts(char *s)
{
	while (*s) {
		uart_putc(*s++);
	}
}

int uart_getc(void)
{
	if (uart_read_reg(LSR) & LSR_RX_READY){
		return uart_read_reg(RHR);
	} else {
		return -1;
	}
}

/*
 * 处理 uart 中断，由于输入到达而引发，从 trap.c 调用。
 */
void uart_isr(void)
{
	while (1) {
		int c = uart_getc();
		if (c == -1) {
			break;
		} else {
			uart_putc((char)c);
			uart_putc('\n');
		}
	}
}
