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
HTTP_Download() {
        ___method="$1"
        ___url="$2"
        ___filepath="$3"
        ___shasum_type="$4"
        ___shasum_value="$5"
        ___auth_header="$6"


        # validate input
        if [ -z "$___url" ] || [ -z "$___filepath" ]; then
                return 1
        fi

        if [ -z "$(type -t curl)" ] && [ -z "$(type -t wget)" ]; then
                return 1
        fi

        if [ -z "$___method" ]; then
                ___method="GET"
        fi


        # execute
        ## clean up workspace
        rm -rf "$___filepath" &> /dev/null
        mkdir -p "${___filepath%/*}" &> /dev/null

        ## download payload
        if [ ! -z "$___auth_header" ]; then
                if [ ! -z "$(type -t curl)" ]; then
                        curl --location \
                                --header "$___auth_header" \
                                --output "$___filepath" \
                                --request "$___method" \
                                "$___url"
                elif [ ! -z "$(type -t wget)" ]; then
                        wget --max-redirect 16 \
                                --header="$___auth_header" \
                                --output-file"$___filepath" \
                                --method="$___method" \
                                "$___url"
                else
                        return 1
                fi
        else
                if [ ! -z "$(type -t curl)" ]; then
                        curl --location \
                                --output "$___filepath" \
                                --request "$___method" \
                                "$___url"
                elif [ ! -z "$(type -t wget)" ]; then
                        wget --max-redirect 16 \
                                --output-file"$___filepath" \
                                --method="$___method" \
                                "$___url"
                else
                        return 1
                fi
        fi

        if [ ! -f "$___filepath" ]; then
                return 1
        fi

        ## checksum payload
        if [ -z "$___shasum_type" ] || [ -z "$___shasum_value" ]; then
                return 0
        fi

        if [ -z "$(type -t shasum)" ]; then
                return 1
        fi

        case "$___shasum_type" in
        1|224|256|384|512|512224|512256)
                ;;
        *)
                return 1
                ;;
        esac

        ___target_shasum="$(shasum -a "$___shasum_type" "$___filepath")"
        ___target_shasum="${___target_shasum%% *}"
        if [ ! "$___target_shasum" = "$___shasum_value" ]; then
                return 1
        fi


        # report status
        return 0
}




HTTP_Setup() {
        # validate input
        OS::is_command_available "brew"
        if [ $? -ne 0 ]; then
                return 1
        fi

        OS::is_command_available "curl"
        if [ $? -eq 0 ]; then
                return 0
        fi


        # execute
        brew install curl
        if [ $? -ne 0 ]; then
                return 1
        fi


        # report status
        return 0
}
