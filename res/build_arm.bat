@ECHO OFF

IF NOT EXIST build MKDIR build

SET PATH = %PATH%;"F:\Dev\Embedded\RTOS_KL25Z\build"

REM =============              FILES             ===============
REM ============================================================
SET BUILD=CMSIS_CORE
SET PROJECT_NAME=kl25z_rtos
SET SOURCES= ..\src\%PROJECT_NAME%.c 
SET OBJECTS= %PROJECT_NAME%.o startup_mkl25z4.o system_mkl25z4.o


REM ==================         TARGET         ==================
REM ============================================================
SET TARGET=arm-arm-none-eabi
SET BOARD=mkl25z4
SET MCPU=cortex-m0plus
SET MFPU=none
SET ARCH=armv6-m

REM ************************************************************
REM ************************************************************
REM **                                                        **
REM **                      ARMCLANG BUILD                       **
REM **                                                        **
REM ************************************************************
REM ************************************************************

REM =============        COMPILER(ARMARMCLANG)       ==============
REM ============================================================
SET ARMCLANG_COMMON=^
-mcpu=%MCPU% ^
-mfpu=%MFPU% ^
-march=%ARCH% ^
--target=%TARGET% ^
-mfloat-abi=softfp ^
-c ^
-xc ^
-O1 ^
-MD ^
-std=gnu99 ^
-gdwarf-4 ^
-fno-rtti ^
-fno-lto ^
-fno-inline-functions ^
-fshort-wchar ^
-fshort-enums ^
-funsigned-char ^
-ffunction-sections

SET ARMCLANG_WARNINGS=^
-Wall ^
-Wno-packed ^
-Wno-unused-macros ^
-Wno-documentation ^
-Wno-sign-conversion ^
-Wno-missing-noreturn ^
-Wno-reserved-id-macro ^
-Wno-missing-prototypes ^
-Wno-parentheses-equality ^
-Wno-nonportable-include-path ^
-Wno-documentation-unknown-command ^
-Wno-missing-variable-declarations

SET ARMCLANG_FLAGS= %ARMCLANG_COMMON% %AMRCLANG_WARNINGS%

SET ARMCLANG_MACROS=^
-DEBUG ^
-D_RTE_ ^
-D_RTE_ ^
-D__EVAL ^
-DMKL25Z128xxx4

SET ARMCLANG_INCLUDES=^
-I ..\src\ ^
-I ..\RTE\_KL25Z ^
-I ..\RTE\Device\MKL25Z128xxx4 ^
-I F:\Dev\Common\ ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\ARM\CMSIS\5.7.0\CMSIS\Core\Include ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\Keil\Kinetis_KLxx_DFP\1.15.0\Device\Include


REM ====================    LINKER(ARMASM)   ===================
REM ============================================================
SET ARMASM_FLAGS=^
--cpu=Cortex-M0plus ^
--debug ^
--fpu=None ^
--apcs=/softfp ^
--diag_suppress=9931

REM ====================   LINKER(ARMLINK)   ===================
REM ============================================================
SET MEMEORY_LAYOUT=^
--first __Vectors ^
--entry 0x00000000 ^
--rw-base 0x1FFFF000 ^
--ro-base 0x00000000 ^
--entry Reset_Handler

SET ARMLINK_FLAGS= ^
%Memory_Layout% ^
--cpu=Cortex-M0+ ^
--summary_stderr ^
--strict ^
--map ^
--xref ^
--debug ^
--symbols ^
--bestdebug ^
--no_remove ^
--callgraph ^
--info sizes ^
--info totals ^
--info unused ^
--info veneers ^
--info summarysizes ^
--load_addr_map_info ^
--userlibpath=%Libraries% ^
--libpath=C:\Keil_v5\ARM\ARMCLANG\lib ^
--list="..\debug\%PROJECT_NAME%.map" 

REM --scatter ..\res\%PROJECT_NAME%.sct

SET Libraries= "F:\Dev\Embedded\KL25Z Library\Objects\KL25ZLibrary.lib"


REM ************************************************************
REM ************************************************************
REM **                                                        **
REM **                       START BUILD                      **
REM **                                                        **
REM ************************************************************
REM ************************************************************

PUSHD build

ECHO ==========                 COMPILE                ==========
ECHO ============================================================

REM //~ COMPILE MAIN SOURCE FILE
CALL C:\Keil_v5\ARM\ARMCLANG\bin\armclang.exe ^
%ARMCLANG_FLAGS% ^
%ARMCLANG_MACROS% ^
%ARMCLANG_INCLUDES% ^
%SOURCES%

REM //~ COMPILE STARTUP AND SYSTEM ASSEMBLY FILES
CALL C:\Keil_v5\ARM\ARMCLANG\bin\armclang.exe ^
%ARMCLANG_FLAGS% ^
%ARMCLANG_MACROS% ^
%ARMCLANG_INCLUDES% ^
..\RTE\Device\MKL25Z128xxx4\system_MKL25Z4.c

CALL C:\Keil_v5\ARM\ARMCLANG\bin\armasm.exe ^
%ARMASM_FLAGS% ^
%ARMCLANG_INCLUDES% ^
-o startup_MKL25Z4.o ^
..\RTE\Device\MKL25Z128xxx4\startup_MKL25Z4.s


ECHO ==========                  LINK                  ==========
ECHO ============================================================

CALL C:\Keil_v5\ARM\ARMCLANG\bin\armlink.exe ^
%ARMLINK_FLAGS% ^
-o %PROJECT_NAME%.elf %Objects%


REM //~ CONVERT ELF TO BINARY
CALL C:\Keil_v5\ARM\ARMCLANG\bin\fromelf.exe ^
--cpu=Cortex-M0plus ^
--bincombined ^
--output=%PROJECT_NAME%.bin ^
%PROJECT_NAME%.elf

REM //~ OUT TO FILE THE ELF DATA
CALL C:\Keil_v5\ARM\ARMCLANG\bin\fromelf.exe ^
--text ^
-c ^
-s ^
--output=%PROJECT_NAME%.lst ^
%PROJECT_NAME%.elf

REM //~ CORRECT ELF SECTIONS FOR GDB 
CALL F:\Dev_Tools\gcc-arm-none-eabi-10-2020-q4-major\bin\arm-none-eabi-objcopy.exe ^
--update-section ER_RO=%PROJECT_NAME%.bin ^
--remove-section=ER_RW ^
%PROJECT_NAME%.elf

REM //~ OUT TO FILE ELF HEADER
CALL C:\Keil_v5\ARM\ARMCLANG\bin\fromelf.exe ^
--text ^
-g ^
--output=%PROJECT_NAME%.txt ^
%PROJECT_NAME%.elf

POPD
