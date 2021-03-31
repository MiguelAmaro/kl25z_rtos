@ECHO OFF

REM ************************************************************
REM ************************************************************
REM **                                                        **
REM **                      DEFINITIONS                       **
REM **                                                        **
REM ************************************************************
REM ************************************************************

SET Project_Name=kl25z_rtos

REM ==========                JLINK                   ==========
REM ============================================================
SET Command_File_Path= debug\Flash_Command_File.jlink
SET Script_File_Path= debug\Flash.JLinkScript
SET Settings_File_Path= F:\Dev\Embedded\RTOS_KL25Z\debug\JLinkSettings.ini


REM ************************************************************
REM ************************************************************
REM **                                                        **
REM **                    FLASH METHODS                       **
REM **                                                        **
REM ************************************************************
REM ************************************************************


REM //~ METHOD 1: FLash Programming Software
REM CALL C:\"Program Files (x86)"\SEGGER\JLink\JLink.exe -SettingsFile %Settings_File_Path% -CommandFile %Command_File_Path%

REM -SettingsFile %Settings_File_Path%
REM -JLinkScriptFile %Script_File_Path%


ECHO //~ METHOD 2: MSC FUNCTIONALITY( Drag and Drop )

@ECHO ON

COPY /b build\%Project_Name%.bin G:\

@ECHO OFF


