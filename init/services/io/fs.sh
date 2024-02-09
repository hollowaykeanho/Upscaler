#!/bin/sh
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
FS_Append_File() {
        #__target="$1"
        #__content="$2"


        # validate target
        if [ ! -z "$1" -a -z "$2" ] || [ -z "$1" ]; then
                return 1
        fi


        # perform file write
        printf -- "%b" "$2" >> "$1"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Copy_All() {
        #__source="$1"
        #__destination="$2"


        # validate input
        if [ -z "$1" ] || [ -z "$2" ]; then
                return 1
        fi


        # execute
        cp -r "${1}"* "${2}/."


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Copy_File() {
        #__source="$1"
        #__destination="$2"


        # validate input
        if [ -z "$1" ] || [ -z "$2" ]; then
                return 1
        fi


        # execute
        cp "$1" "$2"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi
        return 1
}




FS_Extension_Remove() {
        printf -- "%s" "$(FS_Extension_Replace "$1" "$2" "")"
        return $?
}




FS_Extension_Replace() {
        #___target="$1"
        #___extension="$2"
        #___candidate="$3"


        # validate input
        if [ -z "$1" ]; then
                printf -- ""
                return 0
        fi


        # execute
        if [ "$2" = "*" ]; then
                ___target="${1##*/}"
                ___target="${___target%%.*}"

                if [ ! -z "${1%/*}" ] && [ ! "${1%/*}" = "$1" ]; then
                        ___target="${1%/*}/${___target}"
                fi
        elif [ ! -z "$2" ]; then
                if [ "$(printf -- "%.1s" "$2")" = "." ]; then
                        ___extension="${2#*.}"
                else
                        ___extension="$2"
                fi

                ___target="${1##*/}"
                while true; do
                        if [ "${___target#*.}" = "${___extension}" ]; then
                                ___target="${___target%.${___extension}*}"
                                continue
                        fi

                        if [ ! "${___target##*.}" = "${___extension}" ]; then
                                break
                        fi

                        ___target="${___target%.${___extension}*}"
                done

                if [ ! "${___target}" = "${1##*/}" ]; then
                        if [ ! -z "$3" ]; then
                                if [ "$(printf -- "%.1s" "$3")" = "." ]; then
                                        ___target="${___target}.${3#*.}"
                                else
                                        ___target="${___target}.${3}"
                                fi
                        fi
                fi

                if [ ! -z "${1%/*}" ] && [ ! "${1%/*}" = "$1" ]; then
                        ___target="${1%/*}/${___target}"
                fi
        else
                ___target="$1"
        fi

        printf -- "%s" "$___target"
        return 0
}




FS_Get_MIME() {
        #__target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi


        # execute
        ___output="$(file --mime-type "$1")"
        if [ $? -eq 0 ]; then
                printf -- "%b" "${___output##* }"
                return 0
        fi


        # report status
        printf -- ""
        return 1
}




FS_Is_Directory() {
        #__target="$1"


        # execute
        if [ -z "$1" ]; then
                return 1
        fi


        if [ -d "$1" ]; then
                return 0
        fi

        return 1
}




FS_Is_File() {
        #__target="$1"


        # execute
        if [ -z "$1" ]; then
                return 1
        fi

        FS_Is_Directory "$1"
        if [ $? -eq 0 ]; then
                return 1
        fi

        if [ -f "$1" ]; then
                return 0
        fi


        # report status
        return 1
}




FS_Is_Target_Exist() {
        #__target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi


        # perform checking
        FS_Is_Directory "$1"
        if [ $? -eq 0 ]; then
                return 0
        fi

        FS_Is_File "$1"
        if [ $? -eq 0 ]; then
                return 0
        fi


        # report status
        return 1
}




FS_List_All() {
        #__target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi

        FS_Is_Directory "$1"
        if [ $? -ne 0 ]; then
                return 1
        fi


        # execute
        ls -la "$1"
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Make_Directory() {
        #__target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi

        FS_Is_Directory "$1"
        if [ $? -eq 0 ]; then
                return 0
        fi

        FS_Is_Target_Exist "$1"
        if [ $? -eq 0 ]; then
                return 1
        fi


        # execute
        mkdir -p "$1"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Make_Housing_Directory() {
        #__target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi

        FS_Is_Directory "$1"
        if [ $? -eq 0 ]; then
                return 0
        fi


        # perform create
        FS_Make_Directory "${1%/*}"


        # report status
        return $?
}




FS_Move() {
        #__source="$1"
        #__destination="$2"


        # validate input
        if [ -z "$1" ] || [ -z "$2" ]; then
                return 1
        fi


        # execute
        mv "$1" "$2"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Remake_Directory() {
        #__target="$1"


        # execute
        FS_Remove_Silently "$1"
        FS_Make_Directory "$1"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Remove() {
        # __target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi


        # execute
        rm -rf "$1"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Remove_Silently() {
        # __target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 0
        fi


        # execute
        rm -rf "$1" &> /dev/null


        # report status
        return 0
}




FS_Rename() {
        #__source="$1"
        #__target="$2"


        # execute
        FS_Move "$1" "$2"
        return $?
}




FS_Touch_File() {
        #__target="$1"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi

        FS_Is_File "$1"
        if [ $? -eq 0 ]; then
                return 0
        fi


        # execute
        touch "$1"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}




FS_Write_File() {
        #__target="$1"
        #__content="$2"


        # validate input
        if [ -z "$1" ]; then
                return 1
        fi

        FS_Is_File "$1"
        if [ $? -eq 0 ]; then
                return 1
        fi


        # perform file write
        printf -- "%b" "$2" >> "$1"


        # report status
        if [ $? -eq 0 ]; then
                return 0
        fi

        return 1
}
