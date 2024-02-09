# BSD 3-Clause License
#
# Copyright (c) 2024, (Holloway) Chew, Kean Ho
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.




# make sure is by run initialization
if (-not (Test-Path -Path "${env:UPSCALER_PATH_ROOT}")) {
	$null = Write-Error "[ ERROR ] - Please run from init\start.sh.ps1 instead!`n"
	return 1
}




# configure charset encoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$OutputEncoding = [console]::InputEncoding `
		= [console]::OutputEncoding `
		= New-Object System.Text.UTF8Encoding




# determine UPSCALER_PATH_PWD
$env:UPSCALER_PATH_PWD = Get-Location
$env:UPSCALER_PATH_SCRIPTS = "init"


# determine UPSCALER_PATH_ROOT
if (Test-Path ".\start.ps1") {
	# user is inside the init directory.
	${env:UPSCALER_PATH_ROOT} = Split-Path -Parent "${env:UPSCALER_PATH_PWD}"
} elseif (Test-Path ".\${env:UPSCALER_PATH_SCRIPTS}\start.ps1") {
	# current directory is the root directory.
	${env:UPSCALER_PATH_ROOT} = "${env:UPSCALER_PATH_PWD}"
} else {
	# scan from current directory - bottom to top
	$__pathing = "${env:UPSCALER_PATH_PWD}"
	$env:UPSCALER_PATH_ROOT = ""
	foreach ($__pathing in (${env:UPSCALER_PATH_PWD}.Split("\"))) {
		if (-not [string]::IsNullOrEmpty($env:UPSCALER_PATH_ROOT)) {
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
		return 1
	}
}

${env:LIBS_UPSCALER} = "${env:UPSCALER_PATH_ROOT}\${env:UPSCALER_PATH_SCRIPTS}"




# import fundamental libraries
. "${env:LIBS_UPSCALER}\services\io\strings.ps1"
. "${env:LIBS_UPSCALER}\services\compilers\upscaler.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-input-unknown.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-input-unsupported.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-model-unknown.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-scale-unknown.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-unsupported.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\help.ps1"




# execute command
$__help = $false
$__model = ""
$__scale = ""
$__format = ""
$__parallel = ""
$__video = 0
$__batch = 0
$__input = ""
$__output = ""
$__gpu = ""

for ($i = 0; $i -lt $args.Length; $i++) {
	switch ($args[$i]) {
	{ $_ -in "-h", "--help", "help" } {
		$__help = $true
	} "--model" {
		if (-not ($args[$i + 1] -match "^--")) {
			$__model = $args[$i + 1]
			$i++
		}
	} "--scale" {
		if (-not ($args[$i + 1] -match "^--")) {
			$__scale = $args[$i + 1]
			$i++
		}
	} "--format" {
		if (-not ($args[$i + 1] -match "^--")) {
			$__format = $args[$i + 1]
			$i++
		}
	} "--parallel" {
		if (-not ($args[$i + 1] -match "^--")) {
			$__parallel = $args[$i + 1]
			$i++
		}
	} "--video" {
		$__video = 1
	} "--input" {
		if (-not ($args[$i + 1] -match "^--")) {
			$__input = $args[$i + 1]
			$i++
		}
	} "--output" {
		if (-not ($args[$i + 1] -match "^--")) {
			$__output = $args[$i + 1]
			$i++
		}
	} "--gpu" {
		if (-not ($args[$i + 1] -match "^--")) {
			$__gpu = $args[$i + 1]
			$i++
		}
	} default {
	}}
}




# serve help printout and then bail out
if ($__help -eq $true) {
	$null = I18N-Status-Print-Help
	return 0
}




# verify host system is supported
$___process = UPSCALER-Is-Available
if ($___process -ne 0) {
	$null = I18N-Status-Error-Unsupported
	return 1
}




# process model requirements
$___process = UPSCALER-Model-Get "${__model}"
if ((STRINGS-Is-Empty "${___process}") -eq 0) {
	$null = I18N-Status-Error-Model-Unknown
	return 1
}
$___process = $___process -split "│"
$__model = $___process[0]
$__model_name = $___process[2]


$__scale = UPSCALER-Scale-Get $___process[1] $__scale
if (($__scale -le 0) -or ($__scale -gt 4)) {
	$null = I18N-Status-Error-Scale-Unknown
	return 1
}




# process input
$___process = FS-Is-Target-Exist "${__input}"
if ($___process -ne 0) {
	$null = I18N-Status-Error-Input-Unknown
	return 1
}


$__mime = FS-Get-MIME "${__input}"
switch ($__mime) {
{ $_ -in "image/jpeg", "image/png" } {
	$__batch = 0
	$__video = 0
} { $_ -in "video/mp4" } {
	$__batch = 0
	$__video = 1
} "inode/directory" {
	$__batch = 1
} default {
	$null = I18N-Status-Error-Input-Unspported "${__mime}"
	return 1
}}



# placeholder
Write-Host "DEBUG: Model='${__model}' Scale='${__scale}' Format='${__format}' Parallel='${__parallel}' Video='${__video}' Batch='${__batch}' Input='${__input}' Output='${__output}' GPU='${__gpu}'"

return 0
