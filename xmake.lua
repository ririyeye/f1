set_project(f1)

add_rules("mode.release", "mode.debug" , "mode.releasedbg" , "mode.minsizerel")

toolchain("arm-none-eabi")
    set_kind("standalone")
    set_sdkdir("C:\\Program Files (x86)\\GNU Arm Embedded Toolchain\\10 2021.10")
toolchain_end()

target("f1")
    set_kind("binary")
    set_toolchains("arm-none-eabi")
    add_files(
		"./Core/Src/*.c",
        "./startup_stm32f103xb.s",
        "./USB_DEVICE/**.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Src/usbd_cdc.c",

        "./Drivers/STM32F1xx_HAL_Driver/Src/*.c"
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
        "./Drivers/STM32F1xx_HAL_Driver/Inc",
        "./Drivers/STM32F1xx_HAL_Driver/Inc/Legacy",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Inc",
        "./Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc",
        "./Drivers/CMSIS/Device/ST/STM32F1xx/Include",
        "./Drivers/CMSIS/Include"
        )
    add_defines(
        "USE_HAL_DRIVER",
        "STM32F103xB"
    )
    remove_files("Drivers\\STM32F1xx_HAL_Driver\\Src\\stm32f1xx_hal_timebase_tim_template.c")
    remove_files("Drivers\\STM32F1xx_HAL_Driver\\Src\\stm32f1xx_hal_timebase_rtc_alarm_template.c")
    remove_files("Drivers\\STM32F1xx_HAL_Driver\\Src\\stm32f1xx_hal_msp_template.c")
    add_cxflags(
        "-O0",
        "-mcpu=cortex-m3",
        "-mthumb",
        "-Wall -fdata-sections -ffunction-sections",
        "-g -gdwarf-2",{force = true}
        )

    add_asflags(
        "-O0",
        "-mcpu=cortex-m3",
        "-mthumb",
        "-x assembler-with-cpp",
        "-Wall -fdata-sections -ffunction-sections",
        "-g -gdwarf-2",{force = true}
        )

    add_ldflags(
        "-O0",
        "-mcpu=cortex-m3",
        "-mthumb",
        "-L./",
        "-TSTM32F103C8Tx_FLASH.ld",
        "-Wl,--gc-sections",
        "-lc -lm -u _printf_float",{force = true}
        )

    set_targetdir("build")
    set_filename("f1.elf")

    after_build(function(target)
        print("生成HEX 和BIN 文件")
        os.exec("arm-none-eabi-objcopy -O ihex ./build//output.elf ./build//output.hex")
        os.exec("arm-none-eabi-objcopy -O binary ./build//output.elf ./build//output.bin")
        print("生成已完成")
        import("core.project.task")
        -- task.run("flash")
        print("********************储存空间占用情况*****************************")
        os.exec("arm-none-eabi-size -Ax ./build/output.elf")
        os.exec("arm-none-eabi-size -Bx ./build/output.elf")
        os.exec("arm-none-eabi-size -Bd ./build/output.elf")
        print("heap-堆、stck-栈、.data-已初始化的变量全局/静态变量，bss-未初始化的data、.text-代码和常量")
    end)


