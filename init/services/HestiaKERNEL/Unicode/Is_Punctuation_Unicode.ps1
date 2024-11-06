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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Number\Is_Number.ps1"




function HestiaKERNEL-Is-Punctuation-Unicode {
        param (
                [uint32]$___unicode
        )


        # validate input
        if ($(HestiaKERNEL-Is-Number $___unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
        }


        # execute
        if (
                (($___unicode -ge 0x0021) -and ($___unicode -le 0x002F)) -or
                (($___unicode -ge 0x003A) -and ($___unicode -le 0x0040)) -or
                (($___unicode -ge 0x007B) -and ($___unicode -le 0x007E)) -or
                (($___unicode -ge 0x00A1) -and ($___unicode -le 0x00BF)) -or
                (($___unicode -ge 0x2000) -and ($___unicode -le 0x206F)) -or
                (($___unicode -ge 0x2E00) -and ($___unicode -le 0x2E7F)) -or
                (($___unicode -ge 0x3000) -and ($___unicode -le 0x303F)) -or
                (($___unicode -ge 0x12400) -and ($___unicode -le 0x1247F)) -or
                (($___unicode -ge 0x16FE0) -and ($___unicode -le 0x16FFF))
        ) {
                # Latin-1 Script (0x0021-0x002F; 0x003A-0x0040)
                # Latin-1 Suppliment Script (0x00A0-0x00BF)
                # General Punctuation Script (0x2000-0x206F)
                # Supplemental Punctuation Script (0x2E00-0x2E7F)
                # CJK Symbols and Punctuation Script (0x3000-0x303F)
                # Cuneiform Number and Punctuation Script (0x12400-0x1247F)
                # Ideographic Symbols and Punctuation Script (0x16FE0-0x16FFF)
                return ${env:HestiaKERNEL_ERROR_OK}
        }


        # report status
        return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
}
