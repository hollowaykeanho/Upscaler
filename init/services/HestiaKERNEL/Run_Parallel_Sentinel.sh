#!/bin/sh
# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
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
. "${LIBS_HESTIA}/HestiaKERNEL/Error_Codes.sh"




HestiaKERNEL_Run_Parallel_Sentinel() {
        #____parallel_command="$1"
        #____parallel_control_directory="$2"
        #____parallel_available="$3"


        # validate input
        if [ "$1" = "" ]; then
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi

        if [ "$2" = "" ]; then
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ ! -d "$2" ]; then
                return $HestiaKERNEL_ERROR_ENTITY_IS_NOT_DIRECTORY
        fi

        ____parallel_control="${2}/control.txt"
        if [ ! -f "$____parallel_control" ]; then
                return $HestiaKERNEL_ERROR_ENTITY_INVALID
        fi

        ____parallel_available="$3"
        if [ "$____parallel_available" = "" ]; then
                ____parallel_available=$(getconf _NPROCESSORS_ONLN)
        fi


        # execute
        ____parallel_flags="${2}/flags"
        ____parallel_total=0


        # scan total tasks
        ____sync_old_IFS="$IFS"
        while IFS= read -r ____line || [ -n "$____line" ]; do
                ____parallel_total=$(($____parallel_total + 1))
        done < "$____parallel_control"
        IFS="$____sync_old_IFS"
        unset ____sync_old_IFS


        # bail early if no task is available
        if [ $____parallel_total -le 0 ]; then
                return $HestiaKERNEL_ERROR_OK
        fi


        # run in singular when only 1 task is required
        if [ $____parallel_available -le 1 ] || [ $____parallel_total -eq 1 ]; then
                ____sync_old_IFS="$IFS"
                while IFS= read -r ____line || [ -n "$____line" ]; do
                        "$____parallel_command" "$____line"
                        if [ $? -ne 0 ]; then
                                return $HestiaKERNEL_ERROR_BAD_EXEC
                        fi
                done < "$____parallel_control"
                IFS="$____sync_old_IFS"
                unset ____sync_old_IFS


                # report status
                return $HestiaKERNEL_ERROR_OK
        fi


        # run in parallel
        ____parallel_error=0
        ____parallel_done=0
        rm -rf "$____parallel_flags" &> /dev/null
        mkdir -p "$____parallel_flags" &> /dev/null
        while [ $____parallel_done -ne $____parallel_total ]; do
                ____parallel_done=0
                ____parallel_current=0
                ____parallel_working=0


                # scan state
                ____line_number=0
                ____sync_old_IFS="$IFS"
                while IFS= read -r ____line || [ -n "$____line" ]; do
                        ____line_number=$(($____line_number + 1))
                        ____parallel_flag="${____parallel_flags}/l${____line_number}"


                        # skip if error flag is found
                        if [ -d "${____parallel_flag}_error" ]; then
                                ____parallel_error=$(($____parallel_error + 1))
                                continue
                        fi


                        # skip if working flag is found
                        if [ -d "${____parallel_flag}_working" ]; then
                                ____parallel_working=$(($____parallel_working + 1))
                                ____parallel_current=$(($____parallel_current + 1))
                                continue
                        fi


                        # break entire scan when run is completed
                        if [ $____parallel_done -ge $____parallel_total ]; then
                                break
                        fi


                        # skip if done flag is found
                        if [ -d "${____parallel_flag}_done" ]; then
                                ____parallel_done=$(($____parallel_done + 1))
                                ____parallel_current=$(($____parallel_current + 1))
                                continue
                        fi


                        # it's a working state
                        if [ $____parallel_working -lt $____parallel_available ]; then
                                # secure parallel working lock
                                mkdir -p "${____parallel_flag}_working"
                                ____parallel_working=$(($____parallel_working + 1))


                                # initiate parallel execution
                                {
                                        "$1" $____line
                                        case $? in
                                        0)
                                                mkdir -p "${____parallel_flag}_done"
                                                ;;
                                        *)
                                                mkdir -p "${____parallel_flag}_error"
                                                ;;
                                        esac
                                        rm -rf "${____parallel_flag}_working" &> /dev/null
                                } &
                        fi

                        ____parallel_current=$(($____parallel_current + 1))
                done < "$____parallel_control"
                IFS="$____sync_old_IFS"
                unset ____sync_old_IFS


                # stop the entire operation if error is detected and no more
                # running tasks
                if [ $____parallel_error -gt 0 ] && [ $____parallel_working -eq 0 ]; then
                        return $HestiaKERNEL_ERROR_BAD_EXEC
                fi
        done


        # report status
        return $HestiaKERNEL_ERROR_OK
}
