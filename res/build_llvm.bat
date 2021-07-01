@ECHO OFF

IF NOT EXIST build MKDIR build

SET PATH = %PATH%;"F:\Dev\Embedded\RTOS_KL25Z\build"

REM =============              FILES             ===============
REM ============================================================
SET Build=CMSIS_CORE
SET Project_Name=kl25z_rtos
SET SOURCES= ..\src\%Project_Name%.c 
SET Objects= %Project_Name%.o startup_mkl25z4.o system_mkl25z4.o


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
REM **                      CLANG BUILD                       **
REM **                                                        **
REM ************************************************************
REM ************************************************************

REM =============          COMPILER(CLANG)        ==============
REM ============================================================
SET Common= ^
--target=%TARGET% ^
-march=%ARCH% ^
-mcpu=%MCPU% ^
-mfpu=%MFPU% ^
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

SET Warnings= ^
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

SET CLANG_FLAGS= %Common% %Warnings%

SET CLANG_MACROS= ^
-DMKL25Z128xxx4 ^
-D_RTE_ ^
-D__EVAL ^
-D_RTE_ ^
-DDEBUG

SET CLANG_INCLUDES= ^
-I ..\src\ ^
-I F:\Dev\Common\ ^
-I ..\RTE\_KL25Z ^
-I ..\RTE\Device\MKL25Z128xxx4 ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\ARM\CMSIS\5.7.0\CMSIS\Core\Include ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\Keil\Kinetis_KLxx_DFP\1.15.0\Device\Include


REM ====================     LINKER(LLD)     ===================
REM ============================================================
SET Memory_Layout= ^
--first __Vectors ^
--entry 0x00000000 ^
--rw-base 0x1FFFF000 ^
--ro-base 0x00000000 ^
--entry Reset_Handler

SET Common_Linker_Flags= %Memory_Layout% ^
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
--list="..\debug\%Project_Name%.map" 

REM --scatter ..\res\%Project_Name%.sct

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
CALL F:\Dev_Tools\LLVM\bin\clang.exe ^
%CLANG_FLAGS% ^
%CLANG_MACROS% ^
%CLANG_INCLUDES% ^
%SOURCES%

REM //~ COMPILE STARTUP AND SYSTEM ASSEMBLY FILES -----> !!! DOES NOT WORK !!!
CALL F:\Dev_Tools\LLVM\bin\clang.exe ^
%CLANG_FLAGS% ^
%CLANG_MACROS% ^
%CLANG_INCLUDES% ^
..\RTE\Device\MKL25Z128xxx4\system_MKL25Z4.c

REM //~ COMPILE LEGACY ASSMBLY FILE
CALL C:\Keil_v5\ARM\ARMCLANG\bin\armasm.exe ^
--cpu=Cortex-M0plus ^
--debug ^
--diag_suppress=9931 ^
--fpu=None ^
--apcs=/softfp ^
%CLANG_INCLUDES% ^
-o startup_MKL25Z4.o ^
..\RTE\Device\MKL25Z128xxx4\startup_MKL25Z4.S


ECHO ==========                  LINK                  ==========
ECHO ============================================================
CALL F:\Dev_Tools\LLVM\bin\lld-link.exe ^
-help

-mcpu=Cortex-M0+ ^
-o %Project_Name%.elf %Objects% ^
%Common_Linker_Flags% ^
--libpath=C:\Keil_v5\ARM\ARMCLANG\lib ^
--userlibpath=%Libraries%

POPD
