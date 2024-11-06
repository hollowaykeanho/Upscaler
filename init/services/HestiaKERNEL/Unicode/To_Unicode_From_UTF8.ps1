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
. "${env:LIBS_HESTIA}\HestiaKERNEL\List\Is_Array_Byte.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_UTF.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-To-Unicode-From-UTF8 {
        param (
                [byte[]]$___input_content
        )


        # validate input
        if ($___input_content.Length -eq 0) {
                return [uint32[]]@()
        }

        if ($(HestiaKERNEL-Is-Array-Byte $___input_content) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return [uint32[]]@()
        }


        # execute
        ## IMPORTANT NOTICE
        ## PowerShell does not handle UTF-8 byte stream in an isolated manner
        ## without messing up the current terminals' environment variables
        ## (e.g. $OutputEncoding). To avoid it, manual implementations are
        ## required.

        ## check for data encoder
        $___ignore = 0
        $___output = HestiaKERNEL-Is-UTF $___input_content
        if ($($___output -replace "${env:HestiaKERNEL_UTF8_BOM}", '') -ne $___output) {
                # it's UTF8 with BOM marker
                $___ignore = 3
        } elseif ($($___output -replace "${env:HestiaKERNEL_UTF8}", '') -ne $___output) {
                # UTF8 is a candidate
        } else {
                # not a UTF byte array
                return [uint32[]]@()
        }

        $___content = $___input_content
        [System.Collections.Generic.List[uint32]]$___converted = @()
        $___char = [uint32]0
        $___state = 0
        foreach ($___byte in $___content) {
                # ignore BOM markers
                if ($___ignore -gt 0) {
                        $___ignore -= 1
                        continue
                }


                # identify initial state
                if ($___state -ne 0) {
                        # it's a tailing operation - DO NOTHING
                } elseif ($___byte -lt 200) {
                        # x < 0x80 (char < 0x80)
                        $___state = 0
                } elseif (($___byte -gt 193) -and ($___byte -lt 200)) {
                        # 0xBF < x < 0xE0 (char < 0x800)
                        $___state = 1
                } elseif (($___byte -gt 223) -and ($___byte -lt 240)) {
                        # 0xDF < x < 0xF0 (char < 0x10000)
                        $___state = 3
                } else {
                        # 0x10000-0x10FFFF (surrogate pair)
                        $___state = 6
                }

                switch ($___state) {
                9 {
                        $___byte = $___byte -band 0x3F
                        $___char = $___char -bor $___byte
                        $null = $___converted.Add($___char)

                        $___state = 0
                } 8 {
                        $___byte = $___byte -band 0x3F
                        $___byte = $___byte -shl 6
                        $___char = $___char -bor $___byte

                        $___state = 9
                } 7 {
                        $___byte = $___byte -band 0x3F
                        $___byte = $___byte -shl 12
                        $___char = $___char -bor $___byte

                        $___state = 8
                } 6 {
                        # 0x10000-0x10FFFF (surrogate pair)
                        $___byte = $___byte -band 0x07
                        $___char = $___byte -shl 18

                        $___state = 7
                } 5 {
                        $___byte = $___byte -band 0x3F
                        $___char = $___char -bor $___byte
                        $null = $___converted.Add($___char)

                        $___state = 0
                } 4 {
                        $___byte = $___byte -band 0x3F
                        $___byte = $___byte -shl 6
                        $___char = $___char -bor $___byte

                        $___state = 5
                } 3 {
                        # 0xDF < x < 0xF0 (char < 0x10000)
                        $___byte = $___byte -band 0x0F
                        $___char = $___byte -shl 12

                        $___state = 4
                } 2 {
                        $___byte = $___byte -band 0x3F
                        $___char = $___char -bor $___byte
                        $null = $___converted.Add($___char)

                        $___state = 0
                } 1 {
                        # 0xBF < x < 0xE0 (char < 0x800)
                        $___byte = $___byte -band 0x1F
                        $___char = $___byte -shl 6

                        $___state = 2
                } default {
                        # x < 0x80 (char < 0x80)
                        $null = $___converted.Add($___byte)

                        $___state = 0
                }}
        }


        # report status
        return [uint32[]]$___converted
}
