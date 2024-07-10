
#include "./common.h"
#include "cmsis_os.h"

void wifi_proc(commdat* pcom, char* buff)
{
    switch (buff[0]) {
    case 0:
        pcom->beep = !!buff[1];
        break;
    case 1:
        pcom->light = !!buff[1];
        break;
    case 2:
        pcom->fan = !!buff[1];
        break;
    case 3:
        pcom->air_con = !!buff[1];
        break;
    default:
        break;
    }
}

int wifi_write(char* buff, int len)
{
    return hal_uart_write(0, buff, len);
}

static char _buff[128];
void        wifi_recv(void* argument)
{
    commdat* pcom = (commdat*)argument;

    while (1) {
        int len = hal_uart_read(0, _buff, 128);

        if (len < 0) {
            continue;
        }

        wifi_proc(pcom, _buff);
    }
}

void wifi_send(void* argument)
{
    commdat* pcom = (commdat*)argument;

    while (1) {
        osSemaphoreWait(pcom->wifisem, -1);
        wifi_write(pcom->wifi_data, pcom->wifi_len);
        osSemaphoreRelease(pcom->wifisem);
    }
}
