#!/bin/sh
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
# IMPORTANT NOTICE: POSIX Shell does not have class or type declarations so we
#                   will have to be smart about it.




# Error type
HestiaKERNEL_UNICODE_ERROR=4294967295 # 0xFFFFFFFF




# BOM type
HestiaKERNEL_UTF_NO_BOM=0       # default
HestiaKERNEL_UTF_BOM=1




# UTF encoding type
HestiaKERNEL_UTF8=0             # default
HestiaKERNEL_UTF8_BOM=1
HestiaKERNEL_UTF16BE=2          # default
HestiaKERNEL_UTF16BE_BOM=3
HestiaKERNEL_UTF16LE=4
HestiaKERNEL_UTF16LE_BOM=5
HestiaKERNEL_UTF32BE=6          # default
HestiaKERNEL_UTF32BE_BOM=7
HestiaKERNEL_UTF32LE=8
HestiaKERNEL_UTF32LE_BOM=9
HestiaKERNEL_UTF_UNKNOWN=255
