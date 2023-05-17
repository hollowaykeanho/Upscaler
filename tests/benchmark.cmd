echo >/dev/null # >nul & GOTO WINDOWS & rem ^
#
# BSD 3-Clause License
#
# Copyright (c) 2023, (Holloway) Chew, Kean Ho
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
#
################################################################################
# Unix Main Codes                                                              #
################################################################################
if [ -f "./start.cmd" ]; then
        rm -rf ./tests/video/sample-1-640x360-upscaled_workspace &> /dev/null
        rm -rf ./tests/video/sample-1-640x360-upscaled.mp4 &> /dev/null
        time ./start.cmd \
                --model upscayl-ultrasharp-v2 \
                --scale 4 \
                --format webp \
                --video \
                --input tests/video/sample-1-640x360.mp4
else
        printf "[ ERROR ] Please make sure you're at the root location of the repo!\n"
fi
################################################################################
# Unix Main Codes                                                              #
################################################################################
exit $?




:WINDOWS
::##############################################################################
:: Windows Main Codes                                                          #
::##############################################################################
@echo off
setlocal enabledelayedexpansion
if exist start.cmd ( goto :runBenchmark )
echo "[ ERROR ] Please make sure you're at the root location of the repo!"

:runBenchmark
set startTime=!time!
start.cmd ^
		--model upscayl-ultrasharp-v2 ^
		--scale 4 ^
		--format webp ^
		--video ^
		--input tests/video/sample-1-640x360.mp4
set endTime=!time!
set /A elapsedTime=(((1%endTime:~0,2%-100)*60)+1%endTime:~3,2%-100)-(((1%startTime:~0,2%-100)*60)+1%startTime:~3,2%-100)
echo Elapsed time: %elapsedTime% seconds
EXIT /B
::##############################################################################
:: Windows Main Codes                                                          #
::##############################################################################
