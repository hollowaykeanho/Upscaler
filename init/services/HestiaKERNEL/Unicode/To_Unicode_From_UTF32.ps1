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
. "${env:LIBS_HESTIA}\HestiaKERNEL\OS\Endian.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_UTF.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-To-Unicode-From-UTF32 {
        param (
                [byte[]]$___input_content,
                [int]$___input_endian
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
        ## PowerShell does not handle UTF-32 byte stream in an isolated manner
        ## without messing up the current terminals' environment variables
        ## (e.g. $OutputEncoding). To avoid it, manual implementations are
        ## required.
        ##
        ## From the Unicode engineering specification, the default endian is
        ## big-endian.


        # check for data encoder
        $___endian = ${env:HestiaKERNEL_ENDIAN_BIG}
        $___ignore = 0
        $___output = HestiaKERNEL-Is-UTF $___input_content
        if ($($___output -replace "${env:HestiaKERNEL_UTF32LE_BOM}", '') -ne $___output) {
                # it's UTF32LE with BOM marker
                $___endian = ${env:HestiaKERNEL_ENDIAN_LITTLE}
                $___ignore = 4
        } elseif ($($___output -replace "${env:HestiaKERNEL_UTF32BE_BOM}", '') -ne $___output) {
                # it's UTF32BE with BOM marker
                $___endian = ${env:HestiaKERNEL_ENDIAN_BIG}
                $___ignore = 4
        } elseif (
                ($($___output -replace "${env:HestiaKERNEL_UTF32LE}", '') -ne $___output) -and
                ($($___output -replace "${env:HestiaKERNEL_UTF32BE}", '') -ne $___output)
        ) {
                # both UTF32LE or UTF32BE can be a candidate
                if (
                        ($___input_endian -eq ${env:HestiaKERNEL_ENDIAN_LITTLE}) -or
                        ($___input_endian -eq ${env:HestiaKERNEL_ENDIAN_BIG})
                ) {
                        $___endian = $___input_endian # If there is a valid hint, take the hint
                } else {
                        # keep the default
                }
        } else {
                # not a UTF byte array
                return [uint32[]]@()
        }


        # process to unicode
        $___content = [uint32[]]$___input_content
        [System.Collections.Generic.List[uint32]]$___converted = @()
        $___char = [uint32]0
        $___state = 0
        foreach ($___byte in $___content) {
                # ignore BOM markers
                if ($___ignore -gt 0) {
                        $___ignore = $___ignore - 1
                        continue
                }


                # process byte data serially
                switch ($___state) {
                3 {
                        switch ($___endian) {
                        ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                                $___byte = $___byte -shl 24
                                $___char = $___char -bor $___byte
                        } default {
                                $___char = $___char -bor $___byte
                        }}
                        $null = $___converted.Add($___char)

                        $___state = 0
                } 2 {
                        switch ($___endian) {
                        ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                                $___byte = $___byte -shl 16
                                $___char = $___char -bor $___byte
                        } default {
                                $___byte = $___byte -shl 8
                                $___char = $___char -bor $___byte
                        }}

                        $___state = 3
                } 1 {
                        switch ($___endian) {
                        ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                                $___byte = $___byte -shl 8
                                $___char = $___char -bor $___byte
                        } default {
                                $___byte = $___byte -shl 16
                                $___char = $___char -bor $___byte
                        }}

                        $___state = 2
                } default {
                        switch ($___endian) {
                        ${env:HestiaKERNEL_ENDIAN_LITTLE} {
                                $___char = $___byte
                        } default {
                                $___char = $___byte -shl 24
                        }}

                        $___state = 1
                }}
        }


        # report status
        return [uint32[]]$___converted
}
