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
. "${env:LIBS_HESTIA}\HestiaKERNEL\OS\Endian.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-To-UTF16-From-Unicode {
        param (
                [uint32[]]$___unicode,
                [string]$___bom,
                [string]$___endian
        )


        # validate input
        if ($(HestiaKERNEL-Is-Unicode $___unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return [byte[]]@()
        }


        # execute
        [System.Collections.Generic.List[byte]]$___converted = @()


        # prefix BOM if requested
        if ($___bom -eq ${env:HestiaKERNEL_UTF_BOM}) {
                switch ($___endian) {
                ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                        # UTF16LE_BOM - 0xFF, 0xFE
                        $null = $___converted.Add(0xFF)
                        $null = $___converted.Add(0xFE)
                } default {
                        # UTF16BE_BOM (default) - 0xFE, 0xFF
                        $null = $___converted.Add(0xFE)
                        $null = $___converted.Add(0xFF)
                }}
        }


        # convert to UTF-16 bytes list
        foreach ($___char in $___unicode) {
                if ($___char -lt 0x10000) {
                        # char < 0x10000
                        switch ($___endian) {
                        ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                                $___register = $___char -band 0xFF
                                $null = $___converted.Add($___register)

                                $___register = $___char -shr 8
                                $null = $___converted.Add($___register)
                        } default {
                                $___register = $___char -shr 8
                                $null = $___converted.Add($___register)

                                $___register = $___char -band 0xFF
                                $null = $___converted.Add($___register)
                        }}
                } else {
                        # >0x10000 - 0x10000-0x10FFFF (surrogate pair)
                        $___register16 = $___char - 0x10000


                        # high surrogate
                        $___register16 = $___register16 -shr 10
                        $___register16 = $___register16 -band 0x3FF
                        $___register16 += 0xD800
                        switch ($___endian) {
                        ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                                $___register = $___register16 -band 0xFF
                                $null = $___converted.Add($___register)

                                $___register = $___register16 -shr 8
                                $null = $___converted.Add($___register)
                        } default {
                                $___register = $___register16 -shr 8
                                $null = $___converted.Add($___register)

                                $___register = $___register16 -band 0xFF
                                $null = $___converted.Add($___register)
                        }}


                        # low surrogate
                        $___register16 = $___char - 0x10000
                        $___register16 = $___register16 -band 0x3FF
                        $___register16 += 0xDC00
                        switch ($___endian) {
                        ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                                $___register = $___register16 -band 0xFF
                                $null = $___converted.Add($___register)

                                $___register = $___register16 -shr 8
                                $null = $___converted.Add($___register)
                        } default {
                                $___register = $___register16 -shr 8
                                $null = $___converted.Add($___register)

                                $___register = $___register16 -band 0xFF
                                $null = $___converted.Add($___register)
                        }}
                }
        }


        # report status
        return [byte[]]$___converted
}
