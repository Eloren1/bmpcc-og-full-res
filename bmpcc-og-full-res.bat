@echo off
setlocal enabledelayedexpansion

rem File name: bmpcc-og-full-res.bat

rem Guide available at: https://www.youtube.com/watch?v=lVFtVLCurk4

rem Get the current time in HH:MM:SS format
for /f "tokens=1-3 delims=:.," %%a in ("%time%") do set startTime=%%a:%%b:%%c

echo [%startTime%] Starting script...
set "folderCount=0"

rem Loop through all subfolders
for /d %%d in (*) do (
    if exist "%%d\*.dng" (
        if exist "%%d\done.txt" (
            echo %%d: Skipped
        ) else (
            pushd "%%d"

            rem Remove any existing exiftool temporary files if they exist
            if exist *.dng_exiftool_tmp (
                del /f /q *.dng_exiftool_tmp
            )

            rem Set the default resolution and origin for images
            echo %%d: Setting resolution to 1952x1112px 
            exiftool -IFD0:DefaultCropSize="1952 1112" -IFD0:DefaultCropOrigin="0 0" -overwrite_original *.dng

            rem Create done.txt to mark this folder as processed
            echo. > done.txt

            popd
            set /a folderCount+=1
        )
    )
)

rem Get the end time in HH:MM:SS format
for /f "tokens=1-3 delims=:.," %%a in ("%time%") do set endTime=%%a:%%b:%%c
echo [%endTime%] Finished processing %folderCount% folders

pause
endlocal