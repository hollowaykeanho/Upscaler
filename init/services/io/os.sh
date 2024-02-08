# BSD 3-Clause License
#
# Copyright (c) 2024, (Holloway) Chew, Kean Ho
# All rights reserved.
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
OS_Is_Command_Available() {
        # __command="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi


        # execute
        if [ ! -z "$(type -t "$1")" ]; then
                return 0
        fi
        return 1
}




OS_Host_Arch() {
        __arch="$(printf "$(uname -m)" | tr '[:upper:]' '[:lower:]')"
        case "${__arch}" in
        i686-64)
                __arch='ia64' # Intel Itanium.
                ;;
        i386|i486|i586|i686)
                __arch='i386'
                ;;
        x86_64)
                __arch="amd64"
                ;;
        sun4u)
                __arch='sparc'
                ;;
        "power macintosh")
                __arch='powerpc'
                ;;
        ip*)
                __arch='mips'
                ;;
        *)
                ;;
        esac
        printf -- "%s" "$__arch"


        # report status
        if [ -z "$__arch" ]; then
                return 1
        fi

        return 0
}




OS_Host_System() {
        __os="$(echo "$(uname)" | tr '[:upper:]' '[:lower:]')"
        case "$__os" in
        windows*|ms-dos*)
                __os='windows'
                ;;
        cygwin*|mingw*|mingw32*|msys*)
                __os='windows'
                ;;
        *freebsd)
                __os='freebsd'
                ;;
        dragonfly*)
                __os='dragonfly'
                ;;
        *)
                ;;
        esac
        printf -- "%s" "$__os"


        # report status
        if [ -z "$__os" ]; then
                return 1
        fi

        return 0
}
