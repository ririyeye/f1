set_project(f1)
add_rules("mode.release", "mode.debug" , "mode.releasedbg" , "mode.minsizerel")
add_rules("plugin.vsxmake.autoupdate" , {outputdir="."})
toolchain("arm-none-eabi")
    set_kind("standalone")
    if is_host("windows") then
        set_sdkdir("C:\\Program Files (x86)\\GNU Arm Embedded Toolchain\\10 2021.10")
    else
        set_sdkdir("/home/wangyang/toolchain/xpack-arm-none-eabi-gcc-13.2.1-1.1")
    end
toolchain_end()

local optim = ""
local mcu = "-mcpu=cortex-m3 -fdata-sections -ffunction-sections"

set_warnings("all", "extra" , "pedantic")
add_defines(
    "STM32_THREAD_SAFE_STRATEGY=5",
    "USE_HAL_DRIVER",
    "STM32F103xB"
)
add_cxflags(
    optim,
    mcu,
    {force = true}
    )

add_asflags(
    optim,
    mcu,
    "-x assembler-with-cpp",
    {force = true}
    )

add_ldflags(
    mcu,
    "--specs=nano.specs",
    "-TSTM32F103C8Tx_FLASH.ld",
    "-Wl,--gc-sections",
    "-Wl,--print-memory-usage",
    "-u _printf_float",{force = true}
    )
set_arch("arm")
set_plat("cross")
set_toolchains("arm-none-eabi")

set_policy("build.optimization.lto", true)
target("f1")
    set_kind("binary")
    add_files(
        "newlib_lock_glue.c",
        "Core/Src/main.c",
        "Core/Src/freertos.c",
        "Core/Src/stm32f1xx_it.c",
        "Core/Src/stm32f1xx_hal_msp.c",
        "Core/Src/stm32f1xx_hal_timebase_tim.c",
        "USB_DEVICE/App/usb_device.c",
        "USB_DEVICE/App/usbd_desc.c",
        "USB_DEVICE/App/usbd_custom_hid_if.c",
        "USB_DEVICE/Target/usbd_conf.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio_ex.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd_ex.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_usb.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash_ex.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_exti.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim.c",
        "Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim_ex.c",
        "Core/Src/system_stm32f1xx.c",
        "Middlewares/Third_Party/FreeRTOS/Source/croutine.c",
        "Middlewares/Third_Party/FreeRTOS/Source/event_groups.c",
        "Middlewares/Third_Party/FreeRTOS/Source/list.c",
        "Middlewares/Third_Party/FreeRTOS/Source/queue.c",
        "Middlewares/Third_Party/FreeRTOS/Source/stream_buffer.c",
        "Middlewares/Third_Party/FreeRTOS/Source/tasks.c",
        "Middlewares/Third_Party/FreeRTOS/Source/timers.c",
        "Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS_V2/cmsis_os2.c",
        "Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang/heap_4.c",
        "Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM3/port.c",
        "Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c",
        "Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c",
        "Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c",
        "Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_help.c",
        "Middlewares/ST/STM32_USB_Device_Library/Class/CustomHID/Src/usbd_customhid.c",
        "Core/Src/sysmem.c",
        "Core/Src/syscalls.c",
        "startup_stm32f103xb.s"
    )


    add_includedirs(
            "./Core/Inc",
            "./USB_DEVICE/App",
            "./USB_DEVICE/Target",
            "./Drivers/STM32F1xx_HAL_Driver/Inc",
            "./Drivers/STM32F1xx_HAL_Driver/Inc/Legacy",
            "./Middlewares/Third_Party/FreeRTOS/Source/include",
            "./Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS_V2",
            "./Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM3",
            "./Middlewares/ST/STM32_USB_Device_Library/Core/Inc",
            "Middlewares/ST/STM32_USB_Device_Library/Class/CustomHID/Inc",
            "./Drivers/CMSIS/Device/ST/STM32F1xx/Include",
            "./Drivers/CMSIS/Include"
        )
    add_links(
        "c",
        "m"
    )
    set_targetdir("build")
    set_filename("f1.elf")
