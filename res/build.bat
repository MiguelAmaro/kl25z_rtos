@ECHO OFF

SET COMPILER=%1
SET LANGUAGE=%2

IF %COMPILER%==--gnu  (CALL build_gnu.bat %LANGUAGE%)

IF %COMPILER%==--llvm (CALL build_llvm.bat %LANGUAGE%)

IF %COMPILER%==--arm  (CALL build_arm.bat %LANGUAGE%)

EXIT /B 0

