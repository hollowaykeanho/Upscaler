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
TIME_Format_ISO8601_Date() {
        #___epoch="$1"


        # validate input
        if [ -z "$1" ]; then
                printf -- ""
                return 1
        fi

        TIME_Is_Available
        if [ $? -ne 0 ]; then
                return 1
        fi


        # execute
        if [ "$(echo "$(uname)" | tr '[:upper:]' '[:lower:]')" = "darwin" ]; then
                printf -- "%b" "$(date -j -f "%s" "${1}" +"%Y-%m-%d")"
        else
                printf -- "%b" "$(date --date="@${1}" +"%Y-%m-%d")"
        fi


        # report status
        return 0
}




TIME_Is_Available() {
        # execute
        if [ -z "$(type -t date)" ]; then
                return 1
        fi


        # report status
        return 0
}




TIME_Now() {
        # validate input
        TIME_Is_Available
        if [ $? -ne 0 ]; then
                return 1
        fi


        # execute
        printf -- "%b" "$(date -u '+%s')"


        # report status
        return 0
}
