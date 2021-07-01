@echo off

if not exist build mkdir build

rem FILES
rem ************************************************************
set BUILD=CMSIS_CORE
set PROJECT_NAME=kl25z_rtos
set SOURCES= ..\src\%PROJECT_NAME%.c 
set OBJECTS= %PROJECT_NAME%.o startup_MKL25Z4.o system_MKL25Z4.o


rem TARGET
rem ************************************************************
set TARGET=arm-arm-none-eabi
set BOARD=mkl25z4
set MCPU=cortex-m0plus
set MFPU=none
set ARCH=armv6-m


rem BUILD TOOLS
rem ************************************************************
set GCC=F:\Dev_Tools\ARMGNU\bin\arm-none-eabi-gcc.exe
set LD=F:\Dev_Tools\ARMGNU\bin\arm-none-eabi-ld.exe
set OBJDUMP=F:\Dev_Tools\ARMGNU\bin\arm-none-eabi-objdump.exe
set READELF=F:\Dev_Tools\ARMGNU\bin\arm-none-eabi-readelf.exe


rem ************************************************************
rem COMPILER(ARMGCC) OPTIONS
rem ************************************************************

set GCC_COMMON=^
-mcpu=%MCPU% ^
-march=%ARCH% ^
-c -std=gnu99 ^
-O1 ^
-gdwarf-4 ^
-fno-lto -fno-inline-functions ^
-fshort-wchar ^
-funsigned-char ^
-ffunction-sections

set GCC_WARNINGS=^
-Wno-packed ^
-Wno-unused-macros ^
-Wno-sign-conversion ^
-Wno-missing-noreturn ^
-Wno-missing-prototypes

set GCC_FLAGS=%GCC_COMMON% %GCC_WARNINGS%

set GCC_MACROS=^
-DMKL25Z128xxx4 ^
-D_RTE_ ^
-D_RTE_ ^
-DDEBUG ^
-D__EVAL

set GCC_INCLUDE_PATHS= ^
-I ..\src\ ^
-I ..\src\systems\mkl25z128xxx4\ ^
-I F:\Dev\Common\ ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\ARM\CMSIS\5.7.0\CMSIS\Core\Include ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\Keil\Kinetis_KLxx_DFP\1.15.0\Device\Include


rem ************************************************************
rem LINKER(ARMLD) OPTIONS
rem ************************************************************

set LD_MEMORY=^
--first __Vectors ^
--entry 0x00000000 ^
--rw-base 0x1FFFF000 ^
--ro-base 0x00000000 ^
--entry Reset_Handler

set LD_FLAGS= ^
-nostdlib ^
-L F:\Dev_Tools\ARMGNU\lib\gcc\arm-none-eabi\10.2.1\thumb\v6-m\nofp ^
-lgcc ^
-T ..\res\%PROJECT_NAME%.sct

rem --summary_stderr --map --xref --strict --debug ^
rem --symbols --bestdebug --no_remove --callgraph ^
rem --info sizes --info totals --info unused --info veneers ^
rem --info summarysizes --load_addr_map_info ^
rem --list="..\debug\%PROJECT_NAME%.map" 

set LD_LIBRARIES=


rem ************************************************************
rem START BUILD
rem ************************************************************
set path = "F:\Dev\Embedded\RTOS_KL25Z\build";path

pushd build

rem ==========                 COMPILE                ==========
rem ============================================================
%GCC% %GCC_FLAGS% %GCC_MACROS% %GCC_INCLUDE_PATHS% ^
-o gnu_%PROJECT_NAME%.axf ^
%SOURCES%

rem //~ COMPILE STARTUP AND SYSTEM ASSEMBLY FILES
rem call %GCC% %GCC_FLAGS% %GCC_MACROS% %GCC_INCLUDE_PATHS% ^
rem ..\src\systems\mkl25z128xxx4\system_MKL25Z4.c

rem //~ COMPILE LEGACY ASSMBLY FILE
%GCC% %GCC_FLAGS% %GCC_MACROS% %GCC_INCLUDE_PATHS% ^
-o startup_MKL25Z4.o ^
..\src\systems\mkl25z128xxx4\gnu_startup_MKL25Z4.s

echo ==========                  LINK                  ==========
rem  ============================================================
%LD% -o gnu_%PROJECT_NAME%.elf %OBJECTS% %LD_FLAGS%



echo ==========               DEBUG SHIT               ==========
rem  ============================================================
call %OBJDUMP% -h -t gnu_%PROJECT_NAME%.axf

rem call %READELF% -h gnu_%PROJECT_NAME%.elf

popd

pause
