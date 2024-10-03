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
. "${env:LIBS_HESTIA}\HestiaOS\Exec.ps1"
. "${env:LIBS_HESTIA}\HestiaOS\Get_Arch.ps1"
. "${env:LIBS_HESTIA}\HestiaOS\Is_Command_Available.ps1"
. "${env:LIBS_HESTIA}\HestiaOS\Is_Simulation_Mode.ps1"
. "${env:LIBS_HESTIA}\HestiaOS\To_Arch.ps1"
. "${env:LIBS_HESTIA}\HestiaOS\To_Arch_MSFT.ps1"
. "${env:LIBS_HESTIA}\HestiaOS\To_Arch_UNIX.ps1"
. "${env:LIBS_HESTIA}\HestiaOS\To_OS.ps1"
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
return
<#
RUN_AS_POWERSHELL




################################################################################
# Unix Main Codes                                                              #
################################################################################
. "${LIBS_HESTIA}/HestiaOS/Exec.sh"
. "${LIBS_HESTIA}/HestiaOS/Get_Arch.sh"
. "${LIBS_HESTIA}/HestiaOS/Is_Command_Available.sh"
. "${LIBS_HESTIA}/HestiaOS/Is_Simulation_Mode.sh"
. "${LIBS_HESTIA}/HestiaOS/To_Arch.sh"
. "${LIBS_HESTIA}/HestiaOS/To_Arch_MSFT.sh"
. "${LIBS_HESTIA}/HestiaOS/To_Arch_UNIX.sh"
. "${LIBS_HESTIA}/HestiaOS/To_OS.sh"
################################################################################
# Unix Main Codes                                                              #
################################################################################
return 0
#>
