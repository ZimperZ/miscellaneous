PUSHD %~dp0

SET _upd=HPBIOSUPDREC.exe
SET bios=%1

IF /I "%PROCESSOR_ARCHITECTURE%" EQU "AMD64" (
	SET _upd=HPBIOSUPDREC64.exe
)

"%_upd%" -pBIOSPW.bin -f%bios% -s -r

POPD

IF %ERRORLEVEL% NEQ 282 (
	IF %ERRORLEVEL% NEQ 273 (
		EXIT /B 3010
	)
)
