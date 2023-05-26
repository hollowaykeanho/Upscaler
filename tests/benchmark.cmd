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
if [ ! -f "./start.cmd" ]; then
	printf "[ ERROR ] Please make sure you're at the root location of the repo!\n"
	exit 1
fi


rm -rf ./tests/video/sample-1-640x360-upscaled_workspace &> /dev/null
rm -rf ./tests/video/sample-1-640x360-upscaled.mp4 &> /dev/null
start="$(date +%s)"
./start.cmd \
	--model upscayl-ultrasharp-v2 \
	--scale 4 \
	--format webp \
	--video \
	--input tests/video/sample-1-640x360.mp4
end="$(date +%s)"
printf "Elapsed time: $(($end - $start)) seconds.\n"
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
EXIT /B


:runBenchmark
RMDIR /S /Q .\tests\video\sample-1-640x360-upscaled_workspace 2>null
del .\tests\video\sample-1-640x360-upscaled.mp4 2>null

set startTime=%time%
call start.cmd ^
	--model upscayl-ultrasharp-v2 ^
	--scale 4 ^
	--format webp ^
	--video ^
	--input tests\video\sample-1-640x360.mp4
set endTime=%time%


::calculateTiming
set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%startTime%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%endTime%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours%
if 1%ms% lss 100 set ms=0%ms%
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
echo Elapsed time: %totalsecs% seconds.
::##############################################################################
:: Windows Main Codes                                                          #
::##############################################################################
EXIT /B
