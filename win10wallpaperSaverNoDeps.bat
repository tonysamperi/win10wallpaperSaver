@echo off
setlocal enabledelayedexpansion
ECHO #################################
ECHO #################################
ECHO WIN 10 WALLPAPER SAVER BY TONY SAMPERI
ECHO #################################
ECHO #################################
set /a c=1
set minByteSize=768000
set folderName=Assets
set defaultExt=.jpg
set sourcePath=%UserProfile%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
set desktopPath=%UserProfile%\Desktop
REM echo folder name is %folderName%
REM echo source path is %sourcePath%
REM echo desktop path is %desktopPath%
cd %desktopPath%
IF exist %folderName% (
	echo Directory %folderName% already exists
) ELSE (
	mkdir %folderName%
)
set targetPath=%desktopPath%\%folderName%
echo target path is %targetPath%
cd %sourcePath%
echo changed path to %cd%
for %%F in (.\*) do (
	set duplicateCount=0
	set size=%%~zF
	set name=%%~nF
	IF !size! LSS %minByteSize% (
		REM echo.!name!  is ^< %minByteSize% bytes
	) ELSE (
		echo ##### File !c! #####
		REM echo.!name! is ^>= %minByteSize% bytes
		set "fileName=!name!%defaultExt%"
		IF exist "%targetPath%\!fileName!" (
			echo File !fileName! already exists.
			:actionRequired
			call :listAnswers
			echo answer is !answer!
			IF "!answer!" == "B" call :rename
			IF "!answer!" == "O" call :doCopy
			IF "!answer!" == "S" call :skip
			IF answerCheck EQU 1 (
				echo Wrong Answer!
				goto actionRequired
			)
		) ELSE (
			call :doCopy
		)
		set /a c=c+1
	)
)
echo DONE.
REM explorer %targetPath%
START %targetPath%
endlocal
EXIT /B
:listanswers
set answerCheck=1
echo 'B': Keep Both
echo 'O': Overwrite
echo 'S': Skip
echo "Choose (B/O/S)"?
set /P answer=
EXIT /B

:doCopy
set answerCheck=0
echo ##### doCopy section #####
echo source file name is %name%
copy /y %sourcePath%\%name% %targetPath%\!fileName!
EXIT /B
:rename
set answerCheck=0
echo ##### rename section #####
set /a duplicateCount=duplicateCount+1
echo duplicate count is !duplicateCount!
set suffix=" "(!duplicateCount!)
set suffix=%suffix:"=%
set "fileName=!name!!suffix!%defaultExt%"
echo new fileName is !fileName!
IF exist "%targetPath%\!fileName!" (
	echo file already exists. going back.
	goto rename
) ELSE (
	echo new file name is fine!
	call :doCopy
)
EXIT /B

:skip
set answerCheck=0
echo ##### file skipped #####
EXIT /B