set_project(f1)

add_rules("plugin.vsxmake.autoupdate" , {outputdir="."})
toolchain("arm-none-eabi")
    set_kind("standalone")
    -- set_sdkdir("C:\\Program Files (x86)\\GNU Arm Embedded Toolchain\\10 2021.10")
    set_cross("arm-none-eabi-gcc")
toolchain_end()

add_cxflags(
    "-Wpedantic"
)

add_cxxflags(
    "-fno-rtti",
    "-fno-exceptions",
    "-fno-threadsafe-statics"
)

add_ldflags(
    "-Wl,--print-memory-usage"
)
set_arch("arm")
set_plat("cross")

set_policy("build.optimization.lto", true)
target("f1")
    set_kind("binary")
    set_toolchains("arm-none-eabi")
    add_files(
        "./USB_DEVICE/App/usbd_desc.c",
        {cxflags="-O2"}
    )
    add_files(
        "./USB_DEVICE/App/usb_device.c",
        "./USB_DEVICE/App/usbd_cdc_if.c",
        "./USB_DEVICE/Target/*.c",
        {cxflags="-O2"}
    )
    add_files(
        "./Drivers/STM32F1xx_HAL_Driver/Src/*.c",
        "./Core/Src/*.c",
        "./startup_stm32f103xb.s",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Src/usbd_cdc.c",
        {cxflags="-O2"}
    )


    add_includedirs(
        "./Core/Inc",
        "./Drivers/CMSIS/Include",
        "./Drivers/CMSIS/Device/ST/STM32F1xx/Include",
        "./Drivers/STM32F1xx_HAL_Driver/Inc",
        "./Drivers/STM32F1xx_HAL_Driver/Inc/Legacy",
        "./USB_DEVICE/App",
        "./USB_DEVICE/Target",
        "./Core/Inc",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Inc",
        "./Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc"
        )
    add_defines(
        "USE_HAL_DRIVER",
        "STM32F103xB"
    )
    remove_files("Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_timebase_tim_template.c")
    remove_files("Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_timebase_rtc_alarm_template.c")
    remove_files("Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_msp_template.c")
    add_cxflags(
        "-mcpu=cortex-m3",
        "-mthumb",
        "-Wall -fdata-sections -ffunction-sections",
        "-g0",{force = true}
        )

    add_asflags(
        "-mcpu=cortex-m3",
        "-mthumb",
        "-x assembler-with-cpp",
        "-Wall -fdata-sections -ffunction-sections",
        "-g0",{force = true}
        )

    add_ldflags(
        "--specs=nano.specs",
        "-mcpu=cortex-m3",
        "-mthumb",
        "-TSTM32F103C8Tx_FLASH.ld",
        "-Wl,--gc-sections",
        "-u _printf_float",{force = true}
        )
    add_links(
        "c",
        "m"
    )
    set_targetdir("build")
    set_filename("f1.elf")
