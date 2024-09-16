@echo off
setlocal enabledelayedexpansion

:: Specify the input file
set "input_file=domains.txt"

:: Specify the output file
set "output_file=nslookup_results.txt"

:: Clear the output file if it exists
> "%output_file%" echo Results of bulk nslookup:

:: Loop through each line in the input file
for /f "tokens=*" %%d in (%input_file%) do (
    echo Looking up %%d...
    echo %%d >> "%output_file%"
    nslookup %%d >> "%output_file%"
    echo. >> "%output_file%"
)

echo Done. Results are in %output_file%.
endlocal
