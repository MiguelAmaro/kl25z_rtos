@ECHO OFF

ECHO %CD%

REM WHAT IS THE CAUSE OF THE DOUBLE ARROWS
REM make sure device isn't busy with an existin instance of openocd

REM ==========              INSTRUCTIONS              ==========
REM ============================================================
REM ENTER: monitor reset halt
REM AT Reset_Handler() ENTER: start

REM https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads


REM ************************************************************
REM ************************************************************
REM **                                                        **
REM **       RUN OPENOCD & START GBD SERVER - TELNET          **
REM **                                                        **
REM ************************************************************
REM ************************************************************

START cmd /c F:\Dev_Tools\openocd-0.10.0-15\bin\openocd.exe --debug=0 -f ./debug/openocd.cfg -l ./debug/openocd.log"


REM ************************************************************
REM ************************************************************
REM **                                                        **
REM **           OPEN A CMD PROMPT & RUN ARM GBD              **
REM **                                                        **
REM ************************************************************
REM ************************************************************

START cmd /c "F:\Dev_Tools\GNU_Arm_Embedded_Toolchain\bin\arm-none-eabi-gdb.exe --quiet --nx -ex "target extended-remote localhost:3333" -f ./build/kl25z_rtos.axf"



