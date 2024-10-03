echo \" <<'RUN_AS_BATCH' >/dev/null ">NUL "\" \`" <#"
@ECHO OFF
REM LICENSE CLAUSES HERE
REM ----------------------------------------------------------------------------




REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
where /q powershell
if errorlevel 1 (
        echo "ERROR: missing powershell facility."
        exit /b 1
)

copy /Y "%~nx0" "%~n0.ps1" >nul
timeout /t 1 /nobreak >nul
powershell -executionpolicy remotesigned -Command "& '.\%~n0.ps1' %*"
start /b "" cmd /c del "%~f0" & exit /b %errorcode%
REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
RUN_AS_BATCH
#> | Out-Null




echo \" <<'RUN_AS_POWERSHELL' >/dev/null # " | Out-Null
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
. "${env:LIBS_HESTIA}\HestiaKERNEL\Error_Codes.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Is_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Run_Parallel_Sentinel.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_Unicode_From_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_UTF8_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_UTF16_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_UTF32_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode.ps1"
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
return
<#
RUN_AS_POWERSHELL




################################################################################
# Unix Main Codes                                                              #
################################################################################
. "${LIBS_HESTIA}/HestiaKERNEL/Error_Codes.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Run_Parallel_Sentinel.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_Unicode_From_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_UTF8_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_UTF16_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_UTF32_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode.sh"
################################################################################
# Unix Main Codes                                                              #
################################################################################
return 0
#>
