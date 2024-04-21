#include "stm32f1xx_hal.h"

__attribute__((weak)) int _write(int file, char *ptr, int len)
{
	int DataIdx;
 
	for (DataIdx = 0; DataIdx < len; DataIdx++)
	{
		ITM_SendChar( *ptr++ );
	}
	return len;
}

void swoInit(uint32_t portMask, uint32_t cpuCoreFreqHz, uint32_t baudrate)
{
    // baudrate in Hz, note that cpuCoreFreqHz is expected to match the CPU core clock
    uint32_t SWOPrescaler = (cpuCoreFreqHz / baudrate) - 1u;

    CoreDebug->DEMCR = CoreDebug_DEMCR_TRCENA_Msk; // Debug Exception and Monitor Control Register (DEMCR): enable trace
                                                   // in core debug
    // Uncomment following for ST devices
    // DBGMCU->CR = 0x00000027u;                      // DBGMCU_CR : TRACE_IOEN DBG_STANDBY DBG_STOP 	DBG_SLEEP
    TPI->SPPR  = 0x00000002u;  // Selected PIN Protocol Register: Select which protocol to use for trace output (2: SWO)
    TPI->ACPR  = SWOPrescaler; // Async Clock Prescaler Register: Scale the baud rate of the asynchronous output
    ITM->LAR = 0xC5ACCE55u; // ITM Lock Access Register: C5ACCE55 enables more write access to Control Register 0xE00 ::
                            // 0xFFC
    ITM->TCR  = 0x0001000Du;          // ITM Trace Control Register
    ITM->TPR  = ITM_TPR_PRIVMASK_Msk; // ITM Trace Privilege Register: All stimulus ports
    ITM->TER  = portMask;    // ITM Trace Enable Register: Enabled tracing on stimulus ports. One bit per stimulus port.
    DWT->CTRL = 0x400003FEu; // Data Watchpoint and Trace Register
    TPI->FFCR = 0x00000100u; // Formatter and Flush Control Register

    // ITM/SWO works only if enabled from debugger.
    // If ITM stimulus 0 is not free, don't try to send data to SWO
    // if (ITM->PORT [0].u8 == 1)
    // {
    // 	bItmAvailable = 1 ;
    // }
}
