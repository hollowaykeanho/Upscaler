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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\rune_to_title.ps1"

. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Whitespace_Unicode.ps1"




function HestiaKERNEL-To-Titlecase-Unicode {
        param (
                [uint32[]]$___unicode,
                [string]$___locale
        )


        # execute
        if ($(HestiaKERNEL-Is-Unicode $___unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return $___unicode
        }


        # IMPORTANT NOTICE
        # It's tempting to use the for(...arithmetic...) loop -> DON'T. The
        # scanner do perform multiple index increment depending on the scanned
        # contents at the end of an iteration.
        [System.Collections.Generic.List[uint32]]$___converted = @()
        $___index = 0
        $___to_title = "true"
        $___length = $___unicode.Length - 1
        while ($___index -le $___length) {
                # get current character
                $___current = $___unicode[$___index]


                # filter whitespace for titlecasing trigger
                if (
                        ($(HestiaKERNEL-Is-Whitespace-Unicode $___current) -eq ${env:HestiaKERNEL_ERROR_OK}) -and
                        ($___converted -ne "")
                ) {
                        $___to_title = "true"
                        $null = $___converted.Add($___current)
                        $___index += 1
                        continue
                }


                # get next character (look forward by 1)
                $___next = 0
                if (($___length - $___index) -ge 1) {
                        $___next = $___unicode[$___index + 1]
                }


                # get third character (look forward by 2)
                $___third = 0
                if (($___length - $___index) -ge 2) {
                        $___third = $___unicode[$___index + 2]
                }


                # process conversion
                $___ret = hestiakernel-rune-to-title `
                        $___current `
                        $___next `
                        $___third `
                        $___to_title `
                        $___locale
                $___scanned = $___ret -replace "].*$", ''
                $___ret = $___ret -replace "^\[\d*\]", ''
                while ($___ret -ne "") {
                        $___byte = $___ret -replace ",\s.*$", ''
                        $___ret = $___ret -replace "^\d*\,?\s?", ''
                        $null = $___converted.Add([uint32]$___byte)
                }


                # prepare for next scan
                $___to_title = ""
                $___index += [uint32]$___scanned.Substring(1)
        }


        # report status
        return [uint32[]]$___converted
}
