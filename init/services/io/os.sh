#!/bin/sh
# Copyright 2023 (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at:
#                http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
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




OS_Print_Status() {
        __status_mode="$1" && shift 1
        __msg=""
        __color=""

        case "$__status_mode" in
        error)
                __msg="⦗ ERROR ⦘   "
                __color="31"
                ;;
        warning)
                __msg="⦗ WARNING ⦘ "
                __color="33"
                ;;
        info)
                __msg="⦗ INFO ⦘    "
                __color="36"
                ;;
        note)
                __msg="⦗ NOTE ⦘    "
                __color="35"
                ;;
        success)
                __msg="⦗ SUCCESS ⦘ "
                __color="32"
                ;;
        ok)
                __msg="⦗ OK ⦘      "
                __color="36"
                ;;
        done)
                __msg="⦗ DONE ⦘    "
                __color="36"
                ;;
        plain)
                __msg=""
                ;;
        *)
                return 0
                ;;
        esac

        if [ ! -z "$COLORTERM" ] || [ "$TERM" = "xterm-256color" ]; then
                __msg="\033[1;${__color}m${__msg}\033[0;${__color}m${@}\033[0m"
        else
                __msg="${__msg} ${@}"
        fi

        1>&2 printf -- "${__msg}"
        unset __status_mode __msg __color
        return 0
}
