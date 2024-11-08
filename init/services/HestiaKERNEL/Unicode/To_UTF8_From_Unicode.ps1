# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
#
#
# Licensed under (Holloway) Chew, Kean Ho’s Liberal License (the "License").
# You must comply with the license to use the content. Get the License at:
#
#                 https://doi.org/10.5281/zenodo.13770769
#
# You MUST ensure any interaction with the content STRICTLY COMPLIES with
# the permissions and limitations set forth in the license.
. "${env:LIBS_HESTIA}\HestiaKERNEL\Errors\Error_Codes.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-To-UTF8-From-Unicode {
        param (
                [uint32[]]$___unicode,
                [string]$___bom
        )


        # validate input
        if ($(HestiaKERNEL-Is-Unicode $___unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return [byte[]]@()
        }


        # execute
        [System.Collections.Generic.List[byte]]$___converted = @()


        # prefix BOM if requested
        if ($___bom -eq ${env:HestiaKERNEL_UTF_BOM}) {
                # UTF8_BOM - 0xEF, 0xBB, 0xBF
                $null = $___converted.Add(0xEF)
                $null = $___converted.Add(0xBB)
                $null = $___converted.Add(0xBF)
        }


        # convert to UTF-8 bytes list
        foreach ($___char in $___unicode) {
                if ($___char -lt 0x80) {
                        $null = $___converted.Add($___char)
                } elseif ($___char -lt 0x800) {
                        $___register = $___char -shr 6
                        $___register = $___register -band 0x1F
                        $___register = $___register -bor 0xC0
                        $null = $___converted.Add($___register)

                        $___register = $___char -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)
                } elseif ($___char -lt 0x10000) {
                        $___register = $___char -shr 12
                        $___register = $___register -band 0x0F
                        $___register = $___register -bor 0xE0
                        $null = $___converted.Add($___register)

                        $___register = $___char -shr 6
                        $___register = $___register -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)

                        $___register = $___char -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)
                } else {
                        # >0x10000 - 0x10000-0x10FFFF (surrogate pair)
                        $___register = $___char -shr 18
                        $___register = $___register -band 0x07
                        $___register = $___register -bor 0xF0
                        $null = $___converted.Add($___register)

                        $___register = $___char -shr 12
                        $___register = $___register -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)

                        $___register = $___char -shr 6
                        $___register = $___register -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)

                        $___register = $___char -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)
                }
        }


        # report status
        return [byte[]]$___converted
}
