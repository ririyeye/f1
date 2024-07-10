#pragma once

#include "cmsis_os2.h"

typedef struct {
    uint32_t beep      : 1;
    uint32_t light     : 1;
    uint32_t fan       : 1;
    uint32_t air_con   : 1;
    uint32_t light_sta : 1;

    osSemaphoreId_t wifisem;
    int             wifi_data[128];
    char            wifi_len;
} commdat;
