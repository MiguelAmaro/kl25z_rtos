@ECHO OFF

IF NOT EXIST build MKDIR build

SET PATH = %PATH%;"F:\Dev\Embedded\RTOS_KL25Z\build"

REM ************************************************************
REM ************************************************************
REM **                                                        **
REM **                      DEFINITIONS                       **
REM **                                                        **
REM ************************************************************
REM ************************************************************

REM =============              FILES             ===============
REM ============================================================
SET Build=CMSIS_CORE
SET Project_Name=kl25z_rtos
SET Sources= ..\src\%Project_Name%.c 
SET Objects= %Project_Name%.o startup_mkl25z4.o system_mkl25z4.o


REM ==================         TARGET         ==================
REM ============================================================
SET TARGET=arm-arm-none-eabi
SET BOARD=list
SET MCPU=cortex-m0plus
SET MFPU=none
SET ARCH=armv6-m


REM =============        COMPILER(ARMCLANG)     ==============
REM ============================================================
SET Common= ^
-c ^
-xc ^
-O0 ^
-MD ^
-std=c99 ^
-gdwarf-4 ^
-fno-rtti ^
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
-Wno-license-management ^
-Wno-missing-prototypes ^
-Wno-parentheses-equality ^
-Wno-nonportable-include-path ^
-Wno-documentation-unknown-command ^
-Wno-missing-variable-declarations

SET Compiler_Flags= %Common% %Warnings%

SET Compiler_Macros= -DMKL25Z128xxx4 -D_RTE_ -D__EVAL

SET Include_Directories= ^
-I ..\src\ ^
-I F:\Dev\Common\ ^
-I ..\RTE\_KL25Z ^
-I ..\RTE\Device\MKL25Z128xxx4 ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\ARM\CMSIS\5.7.0\CMSIS\Core\Include ^
-I C:\Users\mAmaro\AppData\Local\Arm\Packs\Keil\Kinetis_KLxx_DFP\1.15.0\Device\Include


REM ====================   LINKER(ARMLINK)   ===================
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
--symbols ^
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
CALL C:\Keil_v5\ARM\ARMCLANG\bin\armclang.exe ^
--target=%TARGET% ^
-march=%ARCH% ^
-mcpu=%MCPU% ^
%Compiler_Flags% ^
%Compiler_Macros% ^
%Include_Directories% ^
%Sources%

REM //~ COMPILE OTHER SOURCE FILES
REM CALL C:\Keil_v5\ARM\ARMCLANG\bin\armclang.exe ^
REM --target=%TARGET% ^
REM -march=%ARCH% ^
REM -mcpu=cortex-m0plus ^
REM %Compiler_Flags% ^
REM %Compiler_Macros% ^
REM %Include_Directories% ^
REM ..\src\nRF24L01.c

REM //~ COMPILE STARTUP AND SYSTEM ASSEMBLY FILES -----> !!! DOES NOT WORK !!!
CALL C:\Keil_v5\ARM\ARMCLANG\bin\armclang.exe ^
--target=%TARGET% ^
-march=%ARCH% ^
-mcpu=%MCPU% ^
-mfpu=%MFPU% ^
-mfloat-abi=softfp ^
%Compiler_Flags% ^
%Compiler_Macros% ^
%Include_Directories% ^
..\RTE\Device\MKL25Z128xxx4\system_MKL25Z4.c

REM //~ COMPILE LEGACY ASSMBLY FILE
CALL C:\Keil_v5\ARM\ARMCLANG\bin\armasm.exe ^
--cpu=Cortex-M0plus ^
--debug ^
--diag_suppress=9931 ^
--fpu=None ^
--apcs=/softfp ^
%Include_Directories% ^
-o ^
startup_MKL25Z4.o ^
..\RTE\Device\MKL25Z128xxx4\startup_MKL25Z4.s


ECHO ==========                  LINK                  ==========
ECHO ============================================================

CALL C:\Keil_v5\ARM\ARMCLANG\bin\armlink.exe ^
--cpu=Cortex-M0+ ^
-o %Project_Name%.axf %Objects% ^
%Common_Linker_Flags% ^
--libpath=C:\Keil_v5\ARM\ARMCLANG\lib ^
--userlibpath=%Libraries%

REM //~ MAKE BINARY
CALL C:\Keil_v5\ARM\ARMCLANG\bin\fromelf.exe ^
--cpu=Cortex-M0plus ^
--bincombined ^
--output=%Project_Name%.bin ^
%Project_Name%.axf

CALL C:\Keil_v5\ARM\ARMCLANG\bin\fromelf.exe ^
--text ^
-c ^
-s ^
--output=%Project_Name%.lst ^
%Project_Name%.axf

REM //~ CONVERT AXF TO DEBUGGABLE ELF
CALL C:\Keil_v5\ARM\ARMCLANG\bin\fromelf.exe ^
--output=%Project_Name%.elf ^
%Project_Name%.axf

POPD

PAUSE

