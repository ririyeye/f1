
#include "./common.h"
#include "cmsis_os.h"

static char _buff[128];

void cmd_line(void* argument)
{
    hal_uart_writeline(1, "welcome\n");

    while (1) {
        int len = hal_uart_read(1, _buff, 128);
        if (len < 0) {
            continue;
        }

        switch (_buff[0]) {
        case 0:
            hal_uart_writeline(1, "init ok\n");
            break;
        case 1:
            hal_uart_writeline(1, "turn on air con\n");
            break;
        case 2:
            hal_uart_writeline(1, "turn on fan 1\n");
            break;
        case 3:
            hal_uart_writeline(1, "turn on beep\n");
            break;
        }
    }
}
