set_project(f1)

add_rules("plugin.vsxmake.autoupdate" , {outputdir="."})
toolchain("arm-none-eabi")
    set_kind("standalone")
    set_sdkdir("C:\\Program Files (x86)\\GNU Arm Embedded Toolchain\\10 2021.10")
toolchain_end()

target("f1")
    set_kind("binary")
    set_toolchains("arm-none-eabi")
    add_files(
        "./USB_DEVICE/APP/usbd_desc.c",
        {cflags="-O0"}
    )
    add_files(
        "./USB_DEVICE/APP/usb_device.c",
        "./USB_DEVICE/APP/usbd_cdc_if.c",
        "./USB_DEVICE/Target/*.c",
        {cflags="-O2"}
    )
    add_files(
        "./Drivers/STM32F1xx_HAL_Driver/Src/*.c",
        "./Core/Src/*.c",
        "./startup_stm32f103xb.s",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c",
        "./Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Src/usbd_cdc.c",
        {cflags="-O2"}
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
    remove_files("Drivers\\STM32F1xx_HAL_Driver\\Src\\stm32f1xx_hal_timebase_tim_template.c")
    remove_files("Drivers\\STM32F1xx_HAL_Driver\\Src\\stm32f1xx_hal_timebase_rtc_alarm_template.c")
    remove_files("Drivers\\STM32F1xx_HAL_Driver\\Src\\stm32f1xx_hal_msp_template.c")
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

        local gcc = target:tool("cc")
        local objpath , _ = path.filename(gcc):gsub("gcc", "objcopy.exe")
        local objcopy = path.join(path.directory(gcc), objpath)

        os.vrunv(objcopy, {"-O" ,"ihex" , target:targetfile() , "build//f1.hex"})
        os.vrunv(objcopy, {"-O" ,"binary" , target:targetfile() , "build//f1.bin"})

        print("生成已完成")
        import("core.project.task")
        -- task.run("flash")
        print("********************储存空间占用情况*****************************")
        os.exec("arm-none-eabi-size -Ax ./build/f1.elf")
        os.exec("arm-none-eabi-size -Bx ./build/f1.elf")
        os.exec("arm-none-eabi-size -Bd ./build/f1.elf")
        print("heap-堆、stck-栈、.data-已初始化的变量全局/静态变量,bss-未初始化的data、.text-代码和常量")
    end)
