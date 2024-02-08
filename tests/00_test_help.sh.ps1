echo \" <<'RUN_AS_BATCH' >/dev/null ">NUL "\" \`" <#"
@ECHO OFF
REM LICENSE CLAUSES HERE
REM ----------------------------------------------------------------------------




REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
echo "[ ERROR ]   Use powershell.exe!"
exit /b 1
REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
RUN_AS_BATCH
#> | Out-Null




echo \" <<'RUN_AS_POWERSHELL' >/dev/null # " | Out-Null
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$OutputEncoding = [console]::InputEncoding `
		= [console]::OutputEncoding `
		= New-Object System.Text.UTF8Encoding


# Scan for fundamental pathing
${env:UPSCALER_PATH_PWD} = Get-Location
${env:UPSCALER_PATH_SCRIPTS} = "init"

if (Test-Path ".\start.ps1") {
	# currently inside the automataCI directory.
	${env:UPSCALER_PATH_ROOT} = Split-Path -Parent "${env:UPSCALER_PATH_PWD}"
} elseif (Test-Path ".\${env:UPSCALER_PATH_SCRIPTS}\start.ps1") {
	# current directory is the root directory.
	${env:UPSCALER_PATH_ROOT} = "${env:UPSCALER_PATH_PWD}"
} else {
	# scan from current directory - bottom to top
	$__pathing = "${env:UPSCALER_PATH_PWD}"
	${env:UPSCALER_PATH_ROOT} = ""
	foreach ($__pathing in (${env:UPSCALER_PATH_PWD}.Split("\"))) {
		if (-not [string]::IsNullOrEmpty($env:UPSCLAER_PATH_ROOT)) {
			${env:UPSCALER_PATH_ROOT} += "\"
		}
		${env:UPSCALER_PATH_ROOT} += "${__pathing}"

		if (Test-Path -Path `
			"${env:UPSCALER_PATH_ROOT}\${env:UPSCALER_PATH_SCRIPTS}\start.ps1") {
			break
		}
	}
	$null = Remove-Variable -Name __pathing

	if (-not (Test-Path "${env:UPSCALER_PATH_ROOT}\${env:UPSCALER_PATH_SCRIPTS}\start.ps1")) {
		Write-Error "[ ERROR ] Missing root directory.`n`n"
		exit 1
	}
}

${env:LIBS_UPSCALER} = "${env:UPSCALER_PATH_ROOT}\${env:UPSCALER_PATH_SCRIPTS}"




# import fundamental libraries
. "${env:LIBS_UPSCALER}\services\i18n\__printer.ps1"




# execute suite
$null = I18N-Status-Print "note" "RUNNING HELP TEST SUITE`n`n`n"
$__verdict = $true


$null = I18N-Status-Print "note" "test --help argument...`n"
$__process = ${env:LIBS_UPSCALER}\start.sh.ps1 --help
if ($__process -ne 0) {
	$null = I18N-Status-Print "error" "Failed.`n`n"
	$__verdict = $false
}
$null = I18N-Status-Print "note" "Passed.`n`n"


$null = I18N-Status-Print "note" "test help argument...`n"
$__process = ${env:LIBS_UPSCALER}\start.sh.ps1 help
if ($__process -ne 0) {
	$null = I18N-Status-Print "error" "Failed.`n`n"
	$__verdict = $false
}
$null = I18N-Status-Print "note" "Passed.`n`n"


$null = I18N-Status-Print "note" "test -h argument...`n"
$__process = ${env:LIBS_UPSCALER}\start.sh.ps1 -h
if ($__process -ne 0) {
	$null = I18N-Status-Print "error" "Failed.`n`n"
	$__verdict = $false
}
$null = I18N-Status-Print "note" "Passed.`n`n"


$null = I18N-Status-Print "note" "test German (DE) language...`n"
${env:UPSCALER_LANG} = "DE"
$__process = ${env:LIBS_UPSCALER}\start.sh.ps1 help
if ($__process -ne 0) {
	$null = I18N-Status-Print "error" "Failed.`n`n"
	$__verdict = $false
fi
$null = I18N_Status_Print "note" "Passed.`n`n"




# report verdict
if ($__verdict -ne $true) {
	$null = I18N-Status-Print "error" "TEST SUITE FAILED.`n`n`n"
	exit 1
fi

$null = I18N-Status-Print "success" "TEST SUITE PASSED.`n`n`n"
exit 0


################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
exit $__process
<#
RUN_AS_POWERSHELL




################################################################################
# Unix Main Codes                                                              #
################################################################################
# Scan for fundamental pathing
export UPSCALER_PATH_PWD="$PWD"
export UPSCALER_PATH_SCRIPTS="init"

if [ -f "./start.sh" ]; then
        UPSCALER_PATH_ROOT="${PWD%/*}/"
elif [ -f "./${UPSCALER_PATH_SCRIPTS}/start.sh" ]; then
        # current directory is the root directory.
        UPSCALER_PATH_ROOT="$PWD"
else
        __pathing="$UPSCALER_PATH_PWD"
        __previous=""
        while [ "$__pathing" != "" ]; do
                UPSCALER_PATH_ROOT="${UPSCALER_PATH_ROOT}${__pathing%%/*}/"
                __pathing="${__pathing#*/}"
                if [ -f "${UPSCALER_PATH_ROOT}${UPSCALER_PATH_SCRIPTS}/start.sh" ]; then
                        break
                fi

                # stop the scan if the previous pathing is the same as current
                if [ "$__previous" = "$__pathing" ]; then
                        1>&2 printf "[ ERROR ] Missing root directory.\n"
                        exit 1
                fi
                __previous="$__pathing"
        done
        unset __pathing __previous
        export UPSCALER_PATH_ROOT="${UPSCALER_PATH_ROOT%/*}"

        if [ ! -f "${UPSCALER_PATH_ROOT}/${UPSCALER_PATH_SCRIPTS}/start.sh" ]; then
                1>&2 printf "[ ERROR ] Missing root directory.\n"
                exit 1
        fi
fi

export LIBS_UPSCALER="${UPSCALER_PATH_ROOT}/${UPSCALER_PATH_SCRIPTS}"




# import fundamental libraries
. "${LIBS_UPSCALER}/services/i18n/__printer.sh"




# execute suite
I18N_Status_Print "note" "RUNNING HELP TEST SUITE\n\n\n"
__verdict=0


I18N_Status_Print "note" "test --help argument...\n"
"${LIBS_UPSCALER}"/start.sh.ps1 --help
if [ $? -ne 0 ]; then
	I18N_Status_Print "error" "Failed.\n\n"
	__verdict=1
fi
I18N_Status_Print "note" "Passed.\n\n"


I18N_Status_Print "note" "test help argument...\n"
"${LIBS_UPSCALER}"/start.sh.ps1 help
if [ $? -ne 0 ]; then
	I18N_Status_Print "error" "Failed.\n\n"
	__verdict=1
fi
I18N_Status_Print "note" "Passed.\n\n"


I18N_Status_Print "note" "test -h argument...\n"
"${LIBS_UPSCALER}"/start.sh.ps1 -h
if [ $? -ne 0 ]; then
	I18N_Status_Print "error" "Failed.\n\n"
	__verdict=1
fi
I18N_Status_Print "note" "Passed.\n\n"


I18N_Status_Print "note" "test German (DE) language...\n"
UPSCALER_LANG="DE" "${LIBS_UPSCALER}"/start.sh.ps1 help
if [ $? -ne 0 ]; then
	I18N_Status_Print "error" "Failed.\n\n"
	__verdict=1
fi
I18N_Status_Print "note" "Passed.\n\n"




# report verdict
if [ "$__verdict" != "0" ]; then
	I18N_Status_Print "error" "TEST SUITE FAILED.\n\n\n"
	exit 1
fi

I18N_Status_Print "success" "TEST SUITE PASSED.\n\n\n"
exit 0
################################################################################
# Unix Main Codes                                                              #
################################################################################
exit $?
#>
