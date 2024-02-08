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
DISK_Calculate_Size() {
        #___location="$1"


        # validate input
        if [ -z "$1" ] || [ ! -d "$1" ]; then
                return 1
        fi

        DISK_Is_Available
        if [ $? -ne 0 ]; then
                return 1
        fi


        # execute
        ___size="$(du -ks "$1")"
        if [ $? -ne 0 ]; then
                return 1
        fi

        printf "${___size%%[!0-9]*}"


        # report status
        return 0
}




DISK_Is_Available() {
        # execute
        if [ ! -z "$(type -t du)" ]; then
                return 0
        fi


        # report status
        return 1
}
