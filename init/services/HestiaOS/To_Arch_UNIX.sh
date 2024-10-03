#!/bin/sh
# Copyright (c) 2024, (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
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
HestiaOS_To_Arch_UNIX() {
        #___value="$1"


        # execute
        case "$(printf -- "%b" "$1" | tr '[:upper:]' '[:lower:]')" in
        any|none)
                printf -- "%s" "all"
                ;;
        386|i386|486|i486|586|i586|686|i686)
                printf -- "%s" "i386"
                ;;
        armle)
                printf -- "%s" "armel"
                ;;
        mipsle)
                printf -- "%s" "mipsel"
                ;;
        mipsr6le)
                printf -- "%s" "mipsr6el"
                ;;
        mipsn32le)
                printf -- "%s" "mipsn32el"
                ;;
        mipsn32r6le)
                printf -- "%s" "mipsn32r6el"
                ;;
        mips64le)
                printf -- "%s" "mips64el"
                ;;
        mips64r6le)
                printf -- "%s" "mips64r6el"
                ;;
        powerpcle)
                printf -- "%s" "powerpcel"
                ;;
        ppc64le)
                printf -- "%s" "ppc64el"
                ;;
        *)
                printf -- "%b" "$1" | tr '[:upper:]' '[:lower:]'
                ;;
        esac
        return 0
}
