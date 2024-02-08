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
function OS-Is-Command-Available {
	param (
		[string]$__command
	)


	# validate input
	if ([string]::IsNullOrEmpty($__command)) {
		return 1
	}


	# execute
	$__program = Get-Command $__command -ErrorAction SilentlyContinue
	if ($__program) {
		return 0
	}
	return 1
}




function OS-Exec {
	param (
		[string]$__command,
		[string]$__arguments
	)


	# validate input
	if ([string]::IsNullOrEmpty($__command) -or [string]::IsNullOrEmpty($__arguments)) {
		return 1
	}


	# get program
	$__program = Get-Command $__command -ErrorAction SilentlyContinue
	if (-not ($__program)) {
		return 1
	}


	# execute command
	$__process = Start-Process -Wait `
				-FilePath "$__program" `
				-NoNewWindow `
				-ArgumentList "$__arguments" `
				-PassThru
	if ($__process.ExitCode -ne 0) {
		return 1
	}
	return 0
}
