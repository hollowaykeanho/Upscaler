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




# Data type
# PowerShell cannot directly declare a new data type with primitive data type
# (in this case, uint32[]). Declaring a new class is redundant. Hence, it's
# better to place a notice here specify that the Hestia String is actually
# an array of Runes (Unicode codepoint) which is fundamentally an 'uint32[]'
# array.
#
# type Rune   : uint32
# type String : []Rune || []uint32




# Error type
${env:HestiaKERNEL_UNICODE_ERROR} = [uint32]4294967295 # 0xFFFFFFFF




# BOM type
${env:HestiaKERNEL_UTF_NO_BOM} = 0      # default
${env:HestiaKERNEL_UTF_BOM} = 1




# UTF encoding type
${env:HestiaKERNEL_UTF8} = 0            # default
${env:HestiaKERNEL_UTF8_BOM} = 1
${env:HestiaKERNEL_UTF16BE} = 2         # default
${env:HestiaKERNEL_UTF16BE_BOM} = 3
${env:HestiaKERNEL_UTF16LE} = 4
${env:HestiaKERNEL_UTF16LE_BOM} = 5
${env:HestiaKERNEL_UTF32BE} = 6         # default
${env:HestiaKERNEL_UTF32BE_BOM} = 7
${env:HestiaKERNEL_UTF32LE} = 8
${env:HestiaKERNEL_UTF32LE_BOM} = 9
${env:HestiaKERNEL_UTF_UNKNOWN} = 255
