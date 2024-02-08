#!/bin/sh
# Copyright 2024 (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
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




# To use:
#   $ SYNC_Exec_Parallel "function_name" "${PWD}/parallel.txt" "/tmp/parallel" "4"
#
#   The subroutine function accepts a wrapper function as shown above. Here is
#   an example to construct a simple parallelism executions:
#       function_name() {
#               #___line="$1"
#
#
#               # break line into multiple parameters (delimiter = '|')
#               ___line="${1%|*}"
#
#               ___last="${___line##*|}"
#               ___line="${___line%|*}"
#
#               ___2nd_last="${___line##*|}"
#               ___line="${___line%|*}"
#
#               ...
#
#
#               # some tasks in your thread
#               ...
#
#
#               # execute
#               $@
#               if [ $? -ne 0 ]; then
#                       return 1 # signal an error has occured
#               fi
#
#
#               # report status
#               return 0 # signal a successful execution
#       }
#
#
#       # call the parallel exec
#       SYNC_Exec_Parallel "function_name" "${PWD}/parallel.txt" "/tmp/parallel" "4"
#
#
#   The control file must not have any comment and each line must be the capable
#   of being executed in a single thread. Likewise, when feeding a function,
#   each line is a long string with your own separator. You will have to break
#   it inside your wrapper function.
#
#   The subroutine function **MUST** return **ONLY** the following return code:
#     0 = signal the task execution is done and completed successfully.
#     1 = signal the task execution has error. This terminates the entire run.
SYNC_Exec_Parallel() {
        ___parallel_command="$1"
        ___parallel_control="$2"
        ___parallel_directory="$3"
        ___parallel_available="$4"


        # validate input
        if [ -z "$___parallel_command" ]; then
                return 1
        fi

        if [ -z "$(type -t shasum)" ]; then
                return 1
        fi

        if [ -z "$___parallel_control" ] || [ ! -f "$___parallel_control" ]; then
                return 1
        fi

        if [ -z "$___parallel_available" ]; then
                ___parallel_available=$(getconf _NPROCESSORS_ONLN)
        fi

        if [ $___parallel_available -le 0 ]; then
                ___parallel_available=1
        fi

        if [ -z "$___parallel_directory" ]; then
                ___parallel_directory="${___parallel_control%/*}"
        fi

        if [ ! -d "$___parallel_directory" ]; then
                return 1
        fi


        # execute
        ___parallel_directory="${___parallel_directory}/flags"
        ___parallel_total=0
        ___parallel_current=0
        ___parallel_working=0
        ___parallel_error=0
        ___parallel_done=0


        # scan total tasks
        ___old_IFS="$IFS"
        while IFS= read -r ___line || [ -n "$___line" ]; do
                ___parallel_total=$(($___parallel_total + 1))
        done < "$___parallel_control"
        IFS="$___old_IFS" && unset ___old_IFS


        # end the execution if no task is available
        if [ $___parallel_total -le 0 ]; then
                return 0
        fi


        # run singularly when parallelism is unavailable or has only 1 task
        if [ $___parallel_available -le 1 ] || [ $___parallel_total -eq 1 ]; then
                ___old_IFS="$IFS"
                while IFS= read -r ___line || [ -n "$___line" ]; do
                        "$___parallel_command" "$___line"
                        if [ $? -ne 0 ]; then
                                return 1
                        fi
                done < "$___parallel_control"
                IFS="$___old_IFS" && unset ___old_IFS


                # report status
                return 0
        fi


        # run in parallel
        rm -rf "$___parallel_directory" &> /dev/null
        mkdir -p "$___parallel_directory" &> /dev/null
        while [ $___parallel_done -ne $___parallel_total ]; do
                ___parallel_done=0
                ___parallel_current=0
                ___parallel_working=0

                # scan state
                ___old_IFS="$IFS"
                while IFS= read -r ___line || [ -n "$___line" ]; do
                        ___parallel_flag="$(printf -- "%b" "$___line" | shasum -a 256)"
                        ___parallel_flag="${___parallel_directory}/${___parallel_flag%% *}"

                        # break if error flag is found
                        if [ -d "${___parallel_flag}.parallel-error" ]; then
                                ___parallel_error=$(($___parallel_error + 1))
                                continue
                        fi

                        # skip if working flag is found
                        if [ -d "${___parallel_flag}.parallel-working" ]; then
                                ___parallel_working=$(($___parallel_working + 1))
                                ___parallel_current=$(($___parallel_current + 1))
                                continue
                        fi

                        # break entire scan when run is completed
                        if [ $___parallel_done -eq $___parallel_total ]; then
                                break
                        fi

                        # skip if done flag is found
                        if [ -d "${___parallel_flag}.parallel-done" ]; then
                                ___parallel_done=$(($___parallel_done + 1))
                                ___parallel_current=$(($___parallel_current + 1))
                                continue
                        fi

                        # it is a working state
                        if [ $___parallel_working -lt $___parallel_available ]; then
                                # secure parallel lock
                                mkdir -p "${___parallel_flag}.parallel-working"
                                ___parallel_working=$(($___parallel_working + 1))


                                # initiate parallel execution
                                {
                                        "$___parallel_command" $___line


                                        # release lock
                                        case $? in
                                        0)
                                                mkdir -p "${___parallel_flag}.parallel-done"
                                                ;;
                                        *)
                                                mkdir -p "${___parallel_flag}.parallel-error"
                                                ;;
                                        esac
                                        rm -rf "${___parallel_flag}.parallel-working" \
                                                &> /dev/null
                                } &
                        fi
                        ___parallel_current=$(($___parallel_current + 1))
                done < "$___parallel_control"
                IFS="$___old_IFS" && unset ___old_IFS


                # stop the entire operation if error is detected + no more working tasks
                if [ $___parallel_error -gt 0 -a $___parallel_working -eq 0 ]; then
                        return 1
                fi
        done


        # report status
        return 0
}




# To use:
#   $ SYNC_Exec_Serial "function_name" "${PWD}/parallel.txt"
#
#   The subroutine function accepts a wrapper function as shown above. Here is
#   an example to construct a simple series of executions:
#       function_name() {
#               #___line="$1"
#
#
#               # break line into multiple parameters (delimiter = '|')
#               ___line="${1%|*}"
#
#               ___last="${___line##*|}"
#               ___line="${___line%|*}"
#
#               ___2nd_last="${___line##*|}"
#               ___line="${___line%|*}"
#
#               ...
#
#
#               # some tasks in your thread
#               ...
#
#
#               # execute
#               $@
#               if [ $? -ne 0 ]; then
#                       return 1 # signal an error has occured
#               fi
#
#
#               # report status
#               return 0 # signal a successful execution
#       }
#
#
#       # call the series exec
#       SYNC_Exec_Serial "function_name" "${PWD}/parallel.txt"
#
#
#   The control file must not have any comment and each line must be the capable
#   of being executed in a single thread. Likewise, when feeding a function,
#   each line is a long string with your own separator. You will have to break
#   it inside your wrapper function.
#
#   The subroutine function **MUST** return **ONLY** the following return code:
#     0 = signal the task execution is done and completed successfully.
#     1 = signal the task execution has error. This terminates the entire run.
SYNC_Exec_Serial() {
        ___series_command="$1"
        ___series_control="$2"


        # validate input
        if [ -z "$___series_command" ]; then
                return 1
        fi

        if [ -z "$___series_control" ] || [ ! -f "$___series_control" ]; then
                return 1
        fi


        # execute
        ___old_IFS="$IFS"
        while IFS= read -r ___line || [ -n "$___line" ]; do
                "$___series_command" "$___line"
                if [ $? -ne 0 ]; then
                        return 1
                fi
        done < "$___series_control"
        IFS="$___old_IFS" && unset ___old_IFS


        # report status
        return 0
}
