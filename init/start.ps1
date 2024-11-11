# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
# Copyright 2024 Joly0 [https://github.com/Joly0]
#
#
# BSD 3-Clause License
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
if (-not (Test-Path -Path ${env:UPSCALER_PATH_ROOT})) {
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
        ${env:UPSCALER_PATH_ROOT} = Split-Path -Parent ${env:UPSCALER_PATH_PWD}
} elseif (Test-Path ".\${env:UPSCALER_PATH_SCRIPTS}\start.ps1") {
        # current directory is the root directory.
        ${env:UPSCALER_PATH_ROOT} = ${env:UPSCALER_PATH_PWD}
} else {
        # scan from root directory until the first hit.
        $__pathing = ${env:UPSCALER_PATH_PWD}
        $env:UPSCALER_PATH_ROOT = ""
        foreach ($__pathing in (${env:UPSCALER_PATH_PWD}.Split("\"))) {
                if ($env:UPSCALER_PATH_ROOT -ne "") {
                        ${env:UPSCALER_PATH_ROOT} += "\"
                }
                ${env:UPSCALER_PATH_ROOT} += ${__pathing}

                # stop the scan if the previous pathing is the same as current
                if (Test-Path -Path `
                        "${env:UPSCALER_PATH_ROOT}\${env:UPSCALER_PATH_SCRIPTS}\start.ps1") {
                        return 1
                }
        }
        $null = Remove-Variable -Name __pathing

        if (-not (Test-Path "${env:UPSCALER_PATH_ROOT}\${env:UPSCALER_PATH_SCRIPTS}\start.ps1")) {
                Write-Error "[ ERROR ] Missing root directory.`n`n"
                return 1
        }
}

${env:LIBS_UPSCALER} = "${env:UPSCALER_PATH_ROOT}\${env:UPSCALER_PATH_SCRIPTS}"
${env:LIBS_HESTIA} = "${env:LIBS_UPSCALER}\services"




# import fundamental libraries
. "${env:LIBS_UPSCALER}\services\io\strings.ps1"
. "${env:LIBS_UPSCALER}\services\compilers\ffmpeg.ps1"
. "${env:LIBS_UPSCALER}\services\compilers\upscaler.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-format-unsupported.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-gpu-unsupported.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-input-unknown.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-input-unsupported.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-model-unknown.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-parallel-unsupported.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\report-simulation.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-scale-unknown.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-unsupported.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-video-setup.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\error-video-upscale.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\help.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\report-info.ps1"
. "${env:LIBS_UPSCALER}\services\i18n\report-success.ps1"

### TEST ZONE
Write-Host "---- Index-Left-String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Index_Left_String.ps1"
Write-Host "|$(HestiaKERNEL-Index-Left-String "e你feeeff你你aerg aegE你F" '')|"
Write-Host "|$(HestiaKERNEL-Index-Left-String '' "e你f")|"
Write-Host "|$(HestiaKERNEL-Index-Left-String '' "e你a")|"
Write-Host "|$(HestiaKERNEL-Index-Left-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你F")|"
Write-Host "|$(HestiaKERNEL-Index-Left-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你FX")|"
Write-Host "|$(HestiaKERNEL-Index-Left-String "e你feeeff你你aerg aegE你F" "e你a")|"
Write-Host "|$(HestiaKERNEL-Index-Left-String "e你feeeff你你aerg aegE你F" "e你f")|"
Write-Host "|$(HestiaKERNEL-Index-Left-String "e你feeeff你你aerg aegE你F" "a")|"
Write-Host "|$(HestiaKERNEL-Index-Left-String "e你feeeff你你aerg aegE你F" "你")|"
Write-Host "----"

Write-Host "---- Has_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Has_String.ps1"
Write-Host "|$(HestiaKERNEL-Has-String "e你feeeff你你aerg aegE你F" '')|"
Write-Host "|$(HestiaKERNEL-Has-String '' "e你f")|"
Write-Host "|$(HestiaKERNEL-Has-String '' "e你a")|"
Write-Host "|$(HestiaKERNEL-Has-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你F")|"
Write-Host "|$(HestiaKERNEL-Has-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你FX")|"
Write-Host "|$(HestiaKERNEL-Has-String "e你feeeff你你aerg aegE你F" "e你a")|"
Write-Host "|$(HestiaKERNEL-Has-String "e你feeeff你你aerg aegE你F" "e你f")|"
Write-Host "|$(HestiaKERNEL-Has-String "e你feeeff你你aerg aegE你F" "a")|"
Write-Host "|$(HestiaKERNEL-Has-String "e你feeeff你你aerg aegE你F" "你")|"
Write-Host "----"

Write-Host "---- Has_Any_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Has_Any_String.ps1"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" '')|"
Write-Host "|$(HestiaKERNEL-Has-Any-String '' "e你f")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String '' "e你z")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你F")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你FX")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "e你z")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "e你f")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "a")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "z")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "我")|"
Write-Host "|$(HestiaKERNEL-Has-Any-String "e你feeeff你你aerg aegE你F" "你")|"
Write-Host "----"

Write-Host "---- Trim_Whitespace_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Whitespace_String.ps1"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-String '')|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-String "    ")|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-String "    e你feeeff你你aerg aegE你F    ")|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-String "e你feeeff你你aerg aegE你F    ")|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-String "    e你feeeff你你aerg aegE你F")|"
Write-Host "----"

Write-Host "---- Trim_Whitespace_Left_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Whitespace_Left_String.ps1"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Left-String '')|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Left-String "    ")|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Left-String "    e你feeeff你你aerg aegE你F    ")|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Left-String "e你feeeff你你aerg aegE你F    ")|"
Write-Host "----"

Write-Host "---- Trim_Whitespace_Right_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Whitespace_Right_String.ps1"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Right-String '')|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Right-String "    ")|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Right-String "    e你feeeff你你aerg aegE你F    ")|"
Write-Host "|$(HestiaKERNEL-Trim-Whitespace-Right-String "    e你feeeff你你aerg aegE你F")|"
Write-Host "----"

Write-Host "---- Trim_Left_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Left_String.ps1"
Write-Host "|$(HestiaKERNEL-Trim-Left-String "e你feeeff你你aerg aegE你F" '')|"
Write-Host "|$(HestiaKERNEL-Trim-Left-String '' "e你f")|"
Write-Host "|$(HestiaKERNEL-Trim-Left-String '' "e你a")|"
Write-Host "|$(HestiaKERNEL-Trim-Left-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你F")|"
Write-Host "|$(HestiaKERNEL-Trim-Left-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你FX")|"
Write-Host "|$(HestiaKERNEL-Trim-Left-String "e你feeeff你你aerg aegE你F" "e你a")|"
Write-Host "|$(HestiaKERNEL-Trim-Left-String "e你feeeff你你aerg aegE你F" "e你f")|"
Write-Host "----"

Write-Host "---- Trim_Prefix_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Prefix_String.ps1"
Write-Host "|$(HestiaKERNEL-Trim-Prefix-String "e你feeeff你你aerg aegE你F" '')|"
Write-Host "|$(HestiaKERNEL-Trim-Prefix-String '' "e你f")|"
Write-Host "|$(HestiaKERNEL-Trim-Prefix-String '' "e你a")|"
Write-Host "|$(HestiaKERNEL-Trim-Prefix-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你F")|"
Write-Host "|$(HestiaKERNEL-Trim-Prefix-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你FX")|"
Write-Host "|$(HestiaKERNEL-Trim-Prefix-String "e你feeeff你你aerg aegE你F" "e你a")|"
Write-Host "|$(HestiaKERNEL-Trim-Prefix-String "e你feeeff你你aerg aegE你F" "e你f")|"
Write-Host "----"

Write-Host "---- Trim_Right_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Right_String.ps1"
Write-Host "|$(HestiaKERNEL-Trim-Right-String "e你feeeff你你aerg aegE你F" '')|"
Write-Host "|$(HestiaKERNEL-Trim-Right-String '' "E你F")|"
Write-Host "|$(HestiaKERNEL-Trim-Right-String '' "E你A")|"
Write-Host "|$(HestiaKERNEL-Trim-Right-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你F")|"
Write-Host "|$(HestiaKERNEL-Trim-Right-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你FX")|"
Write-Host "|$(HestiaKERNEL-Trim-Right-String "e你feeeff你你aerg aegE你F" "E你A")|"
Write-Host "|$(HestiaKERNEL-Trim-Right-String "e你feeeff你你aerg aegE你F" "E你F")|"
Write-Host "----"

Write-Host "---- Trim_Suffix_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Trim_Suffix_String.ps1"
Write-Host "|$(HestiaKERNEL-Trim-Suffix-String "e你feeeff你你aerg aegE你F" '')|"
Write-Host "|$(HestiaKERNEL-Trim-Suffix-String '' "e你F")|"
Write-Host "|$(HestiaKERNEL-Trim-Suffix-String '' "e你a")|"
Write-Host "|$(HestiaKERNEL-Trim-Suffix-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你F")|"
Write-Host "|$(HestiaKERNEL-Trim-Suffix-String "e你feeeff你你aerg aegE你F" "e你feeeff你你aerg aegE你FX")|"
Write-Host "|$(HestiaKERNEL-Trim-Suffix-String "e你feeeff你你aerg aegE你F" "e你a")|"
Write-Host "|$(HestiaKERNEL-Trim-Suffix-String "e你feeeff你你aerg aegE你F" "e你F")|"
Write-Host "----"

Write-Host "---- Get_Length_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Get_Length_String.ps1"
Write-Host "$(HestiaKERNEL-Get-Length-String '')"
Write-Host "$(HestiaKERNEL-Get-Length-String "f")"
Write-Host "$(HestiaKERNEL-Get-Length-String "f你你a")"
Write-Host "----"

Write-Host "---- Get_First_Character ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Get_First_Character.ps1"
Write-Host "$(HestiaKERNEL-Get-First-Character '')"
Write-Host "$(HestiaKERNEL-Get-First-Character "s")"
Write-Host "$(HestiaKERNEL-Get-First-Character "你")"
Write-Host "$(HestiaKERNEL-Get-First-Character "sta")"
Write-Host "$(HestiaKERNEL-Get-First-Character "你sa")"
Write-Host "----"

Write-Host "---- Get_Last_Character ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Get_Last_Character.ps1"
Write-Host "$(HestiaKERNEL-Get-Last-Character '')"
Write-Host "$(HestiaKERNEL-Get-Last-Character "s")"
Write-Host "$(HestiaKERNEL-Get-Last-Character "你")"
Write-Host "$(HestiaKERNEL-Get-Last-Character "sta")"
Write-Host "$(HestiaKERNEL-Get-Last-Character "sa你")"
Write-Host "----"

Write-Host "---- Is_Empty_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Is_Empty_String.ps1"
Write-Host "$(HestiaKERNEL-Is-Empty-String '')"
Write-Host "$(HestiaKERNEL-Is-Empty-String "a")"
Write-Host "$(HestiaKERNEL-Is-Empty-String "sa")"
Write-Host "$(HestiaKERNEL-Is-Empty-String "你")"
Write-Host "$(HestiaKERNEL-Is-Empty-String "你sa")"
Write-Host "$(HestiaKERNEL-Is-Empty-String "sa你")"
Write-Host "----"

Write-Host "---- Is_Empty_Unicode ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Empty_Unicode.ps1"
Write-Host "$(HestiaKERNEL-Is-Empty-Unicode @())"
Write-Host "$(HestiaKERNEL-Is-Empty-Unicode @(45))"
Write-Host "$(HestiaKERNEL-Is-Empty-Unicode @(45, 54))"
Write-Host "----"

Write-Host "---- Is_Whitespace_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Is_Whitespace_String.ps1"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String " ")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "m")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "m ")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String " m")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "你")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "你 ")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String " 你")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "你sa")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "你sa ")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String " 你sa")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "sa你")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String "sa你 ")"
Write-Host "$(HestiaKERNEL-Is-Whitespace-String " sa你")"
Write-Host "----"

Write-Host "---- To_Uppercase_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_Uppercase_String.ps1"
Write-Host "$(HestiaKERNEL-To-Uppercase-String " ")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "m")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "m ")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String " m")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "你")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "你 ")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String " 你")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "你sa")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "你sa ")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String " 你sa")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "sa你")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String "sa你 ")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String " sa你")"
Write-Host "$(HestiaKERNEL-To-Uppercase-String " sa你 agawe af")"
Write-Host "----"

Write-Host "---- To_Lowercase_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_Lowercase_String.ps1"
Write-Host "$(HestiaKERNEL-To-Lowercase-String " ")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "m")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "m ")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String " m")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "你")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "你 ")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String " 你")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "你sa")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "你sa ")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String " 你sa")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "sa你")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String "sa你 ")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String " sa你")"
Write-Host "$(HestiaKERNEL-To-Lowercase-String " sa你 agawe af")"
Write-Host "----"

Write-Host "---- To_Titlecase_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_Titlecase_String.ps1"
Write-Host "$(HestiaKERNEL-To-Titlecase-String " ")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "m")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "m ")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String " m")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "你")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "你 ")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String " 你")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "你sa")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "你sa ")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String " 你sa")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "sa你")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String "sa你 ")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String " sa你")"
Write-Host "$(HestiaKERNEL-To-Titlecase-String " sa你 agawe af")"
Write-Host "----"

Write-Host "---- Is_Punctuation_String ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\Is_Punctuation_String.ps1"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String ",")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "m")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "m,")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String ",m")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "你")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "你,")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String ",你")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "你sa")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "你sa,")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String ",你sa")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "sa你")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String "sa你,")"
Write-Host "$(HestiaKERNEL-Is-Punctuation-String ",sa你")"
Write-Host "----"

. "${env:LIBS_HESTIA}\HestiaKERNEL\OS\Endian.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"

Write-Host "---- To_Unicode_From_UTF8 ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_UTF8.ps1"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF8 @())"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF8 @(255, 123, 100, 123, 22, 55, 44, 33))"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF8 @(228, 189, 160, 97, 229, 165, 189, 98))"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF8 @(239, 187, 191, 228, 189, 160, 97, 229, 165, 189, 98))"
### expect 20320, 97, 22909, 98
Write-Host "----"

Write-Host "---- To_UTF8_From_Unicode ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_UTF8_From_Unicode.ps1"
Write-Host "$(HestiaKERNEL-To-UTF8-From-Unicode @())"
Write-Host "$(HestiaKERNEL-To-UTF8-From-Unicode @(20320, 97, 22909, 98))"
### expect 228, 189, 160, 97, 229, 165, 189, 98
Write-Host "$(HestiaKERNEL-To-UTF8-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_BOM})"
### expect 239, 187, 191, 228, 189, 160, 97, 229, 165, 189, 98
Write-Host "----"

Write-Host "---- To_Unicode_From_UTF16 ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_UTF16.ps1"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @())"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(255, 123, 100, 123, 22, 55, 44, 33))"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(79, 96, 0, 97, 89, 125, 0, 98))"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(96, 79, 97, 0, 125, 89, 98, 0) ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(79, 96, 0, 97, 89, 125, 0, 98) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(255, 254, 96, 79, 97, 0, 125, 89, 98, 0) ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(255, 254, 96, 79, 97, 0, 125, 89, 98, 0) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(79, 96, 0, 97, 89, 125, 0, 98) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(254, 255, 79, 96, 0, 97, 89, 125, 0, 98) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF16 @(254, 255, 79, 96, 0, 97, 89, 125, 0, 98) ${env:HestiaKERNEL_ENDIAN_LITTLE})"
### expect 20320, 97, 22909, 98
Write-Host "----"

Write-Host "---- To_UTF16_From_Unicode ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_UTF16_From_Unicode.ps1"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @())"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @() ${env:HestiaKERNEL_UTF_NO_BOM})"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @() ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @() ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @() ${env:HestiaKERNEL_UTF_BOM})"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @() ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @() ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @(20320, 97, 22909, 98))"
### expect 79, 96, 0, 97, 89, 125, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_NO_BOM})"
### expect 79, 96, 0, 97, 89, 125, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
### expect 79, 96, 0, 97, 89, 125, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
### expect 96, 79, 97, 0, 125, 89, 98, 0
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_BOM})"
### expect 254, 255, 79, 96, 0, 97, 89, 125, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
### expect 254, 255, 79, 96, 0, 97, 89, 125, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF16-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
### expect 255, 254, 96, 79, 97, 0, 125, 89, 98, 0
Write-Host "----"

Write-Host "---- To_Unicode_From_UTF32 ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_UTF32.ps1"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @())"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(255, 123, 100, 123, 22, 55, 44, 33))"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98))"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(96, 79, 0, 0, 97, 0, 0, 0, 125, 89, 0, 0, 98, 0, 0, 0) ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(255, 254, 0, 0, 96, 79, 0, 0, 97, 0, 0, 0, 125, 89, 0, 0, 98, 0, 0, 0) ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(255, 254, 0, 0, 96, 79, 0, 0, 97, 0, 0, 0, 125, 89, 0, 0, 98, 0, 0, 0) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(0, 0, 254, 255, 0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98) ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-Unicode-From-UTF32 @(0, 0, 254, 255, 0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98) ${env:HestiaKERNEL_ENDIAN_LITTLE})"
### expect 20320, 97, 22909, 98
Write-Host "----"

Write-Host "---- To_UTF32_From_Unicode ----"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_UTF32_From_Unicode.ps1"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @())"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @() ${env:HestiaKERNEL_UTF_NO_BOM})"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @() ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @() ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @() ${env:HestiaKERNEL_UTF_BOM})"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @() ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @() ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @(20320, 97, 22909, 98))"
### expect 0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_NO_BOM})"
### expect 0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
### expect 0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_NO_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
### expect 96, 79, 0, 0, 97, 0, 0, 0, 125, 89, 0, 0, 98, 0, 0, 0
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_BOM})"
### expect 0, 0, 254, 255, 0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_BIG})"
### expect 0, 0, 254, 255, 0, 0, 79, 96, 0, 0, 0, 97, 0, 0, 89, 125, 0, 0, 0, 98
Write-Host "$(HestiaKERNEL-To-UTF32-From-Unicode @(20320, 97, 22909, 98) ${env:HestiaKERNEL_UTF_BOM} ${env:HestiaKERNEL_ENDIAN_LITTLE})"
### expect 255, 254, 0, 0, 96, 79, 0, 0, 97, 0, 0, 0, 125, 89, 0, 0, 98, 0, 0, 0
Write-Host "----"




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
$___process = UPSCALER-Model-Get $__model
if ($___process -eq "") {
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
$___process = FS-Is-Target-Exist $__input
if ($___process -ne 0) {
        $null = I18N-Status-Error-Input-Unknown
        return 1
}


$__mime = FS-Get-MIME $__input
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
        $null = I18N-Status-Error-Input-Unspported $__mime
        return 1
}}




# process gpu
if ($__gpu -eq "") {
        $__gpu = 0
}

if (${env:UPSCALER_TEST_MODE} -eq "") {
        $___process = UPSCALER-GPU-Verify $__gpu
        if ($___process -ne 0) {
                $null = I18N-Status-Error-GPU-Unsupported $__gpu
                return 1
        }
}




# process parallelism
if ($__parallel -eq "") {
        $__parallel = 1
}

if (-not ($__parallel -match "^[\d]+$")) {
        $null = I18N-Status-Error-Parallel-Unsupported $__parallel
        return 1
}




# process format
if ($__format -eq "") {
        $__format = "native"
}

$__format = UPSCALER-Format-Validate $__format
if ($__format -eq "") {
        $null = I18N-Status-Error-Format-Unsupported
        return 1
}




# execute
if ((${__video} -eq 0) -and (${__batch} -eq 0)) {
        $__output = UPSCALER-Output-Filename-Image $__output $__input $__format


        # report task info
        $null = I18N-Report-Info `
                $__batch `
                $__video `
                $__model `
                $__scale `
                $__format `
                $__parallel `
                $__gpu `
                $__input `
                $__output


        # execute
        $___process = UPSCALER-Run-Image `
                        $__model `
                        $__scale `
                        $__format `
                        $__gpu `
                        $__input `
                        $__output
        if ($___process -eq 0) {
                $null = I18N-Report-Success
                return 0
        }
} elseif ($__video -eq 1) {
        # check upscaler availabiltiy
        if (${env:UPSCALER_TEST_MODE} -ne 0) {
                $null = I18N-Report-Simulation "ffmpeg & ffprobe"
                $___process = 0
        } else {
                $___process = FFMPEG-Is-Available
        }

        if ($___process -ne 0) {
                $null = I18N-Error-FFMPEG-Unavailable
                return 1
        }


        # process output filename
        $__output = UPSCALER-Output-Filename-Video $__output $__input


        # attempt to parse workspace
        $___process = UPSCALER-Batch-Load $__video `
                        $__model `
                        $__scale `
                        $__format `
                        $__parallel `
                        $__gpu `
                        $__input `
                        $__output
        if ($___process -ne 0) {
                $___process = FFMPEG-Video-Dissect $__input $__output
                if ($___process -ne 0) {
                        $null = I18N-Error-FFMPEG-Dissect
                        return 1
                }


                $___process = UPSCALER-Batch-Setup $__video `
                                $__model `
                                $__scale `
                                $__format `
                                $__parallel `
                                $__gpu `
                                $__input `
                                $__output
                if ($___process -ne 0) {
                        $null = I18N-Error-Video-Setup
                        return 1
                }
        }


        # report task info
        $null = I18N-Report-Info `
                $__batch `
                $__video `
                $__model `
                $__scale `
                $__format `
                $__parallel `
                $__gpu `
                $__input `
                $__output


        # execute
        $___process = UPSCALER-Batch-Run $__video `
                        $__model `
                        $__scale `
                        $__format `
                        $__parallel `
                        $__gpu `
                        $__input `
                        $__output
        if ($___process -ne 0) {
                $null = I18N-Error-Video-Upscale
                return 1
        }


        # assemble back to video
        $___process = FFMPEG-Video-Reassemble $__input $__output
        if ($___process -eq 0) {
                $null = I18N-Report-Success
                return 0
        }
} elseif ($__batch -eq 1) {
}



# placeholder
return 0
