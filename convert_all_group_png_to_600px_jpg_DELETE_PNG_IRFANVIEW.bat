@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM  FULL PNG-TO-JPG COMMITMENT BATCH - IRFANVIEW VERSION
REM
REM  Purpose:
REM    Convert every .png image under the "group" folder into a
REM    reduced .jpg image, maximum 600x600 pixels, then delete
REM    the original .png after the JPG is successfully created.
REM
REM  This version uses IrfanView, not ImageMagick.
REM
REM  Put this BAT file in the main program folder, the same
REM  folder that contains the "group" folder.
REM ============================================================

echo.
echo ============================================================
echo   FULL PNG-TO-JPG CONVERSION - IRFANVIEW VERSION
echo ============================================================
echo.
echo This will search inside:
echo   %cd%\group
echo.
echo It will:
echo   1. Convert PNG files to JPG files.
echo   2. Resize images to fit inside 600x600 pixels.
echo   3. Overwrite existing JPG files with the same base name.
echo   4. Delete each PNG only after its JPG is successfully made.
echo.
echo This batch file assumes you already have a complete backup.
echo.
pause

REM ----- Find IrfanView -----
set "IRFAN="

if exist "C:\Program Files\IrfanView\i_view64.exe" set "IRFAN=C:\Program Files\IrfanView\i_view64.exe"
if exist "C:\Program Files (x86)\IrfanView\i_view32.exe" set "IRFAN=C:\Program Files (x86)\IrfanView\i_view32.exe"
if exist "C:\Program Files\IrfanView\i_view32.exe" set "IRFAN=C:\Program Files\IrfanView\i_view32.exe"

if "%IRFAN%"=="" (
    echo.
    echo ERROR: I could not find IrfanView automatically.
    echo.
    echo Look for i_view64.exe on your computer.
    echo It is usually here:
    echo   C:\Program Files\IrfanView\i_view64.exe
    echo.
    echo If yours is somewhere else, edit this BAT file and set IRFAN manually.
    echo.
    pause
    exit /b 1
)

if not exist "group\" (
    echo.
    echo ERROR: I do not see a folder named "group" here.
    echo Put this BAT file in the main program folder that contains "group".
    echo.
    pause
    exit /b 1
)

echo.
echo Using IrfanView:
echo   %IRFAN%
echo.

set /a converted=0
set /a failed=0

echo Starting conversion...
echo.

for /R "group" %%F in (*.png) do (
    echo Converting: %%~fF

    "%IRFAN%" "%%~fF" /resize_long=600 /aspectratio /resample /jpgq=82 /convert="%%~dpnF.jpg"

    if exist "%%~dpnF.jpg" (
        del "%%~fF"
        set /a converted+=1
    ) else (
        echo FAILED: %%~fF
        set /a failed+=1
    )
)

echo.
echo ============================================================
echo   CONVERSION COMPLETE
echo ============================================================
echo.
echo Converted and deleted PNG files: !converted!
echo Failed conversions: !failed!
echo.
echo If failed conversions is 0, the group folder is now committed
echo to JPG image files for those PNGs.
echo.
pause

endlocal
