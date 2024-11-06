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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Errors\Error_Codes.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\List\Is_Array_Byte.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\List\Is_Array_Number.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Number\Is_Number.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\OS\Endian.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\OS\Get_String_Encoder.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Parallelism\Run_Parallel_Sentinel.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Get_First_Character.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Get_Last_Character.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Is_Empty_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Is_Punctuation_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Is_Whitespace_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_Lowercase_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_String_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_Titlecase_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_Uppercase_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Left_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Right_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Get_First_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Get_Last_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Empty_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Punctuation_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_UTF.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Whitespace_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Lowercase_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Titlecase_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_UTF8.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_UTF16.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_UTF32.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Uppercase_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_UTF8_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_UTF16_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_UTF32_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Trim_Left_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Trim_Right_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
return
<#
RUN_AS_POWERSHELL




################################################################################
# Unix Main Codes                                                              #
################################################################################
. "${LIBS_HESTIA}/HestiaKERNEL/Errors/Error_Codes.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/List/Is_Array_Byte.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/List/Is_Array_Number.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Number/Is_Number.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/OS/Endian.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/OS/Get_String_Encoder.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Parallelism/Run_Parallel_Sentinel.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/Get_First_Character.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/Get_Last_Character.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/Is_Empty_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/Is_Punctuation_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/Is_Whitespace_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/To_Lowercase_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/To_String_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/To_Titlecase_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/To_Uppercase_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/Trim_Left_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/String/Trim_Right_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Get_First_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Get_Last_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Empty_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Punctuation_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_UTF.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Whitespace_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Lowercase_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Titlecase_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_UTF8.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_UTF16.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_UTF32.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Uppercase_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_UTF8_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_UTF16_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_UTF32_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Trim_Left_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Trim_Right_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"
################################################################################
# Unix Main Codes                                                              #
################################################################################
return 0
#>
