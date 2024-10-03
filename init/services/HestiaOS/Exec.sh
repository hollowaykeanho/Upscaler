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
. "${LIBS_HESTIA}/hestiaKERNEL/Error_Codes.sh"




HestiaOS_Exec() {
        #___command="$1"
        #___argument="$2"
        #___log_stdout="$3"
        #___log_stderr="$4"


        # validate input
        if [ "$1" = "" ]; then
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute command
        if [ ! "$3" = "" ] || [ ! "$4" = "" ]; then
                "$1" $2 1>"$3" 2>"$4"
        elif [ ! "$3" = "" ]; then
                "$1" $2 1>"$3"
        elif [ ! "$4" = "" ]; then
                "$1" $2 2>"$4"
        else
                "$1" $2
        fi

        if [ $? -ne 0 ]; then
                return $HestiaKERNEL_ERROR_BAD_EXEC
        fi


        # report status
        return $HestiaKERNEL_ERROR_OK
}
################################################################################
# Unix Main Codes                                                              #
################################################################################
return 0
#>
