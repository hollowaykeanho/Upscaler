# Copyright 2024 (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy
# of the License at:
#                 http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
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




function OS-Print-Status {
	param (
		[string]$__mode,
		[string]$__message
	)

	$__tag = ""
	$__color = ""
	$__foreground_color = "Gray"

	switch ($__mode) {
	"error" {
		$__tag = [char]::ConvertFromUtf32(0x2997) `
			+ " ERROR " `
			+ [char]::ConvertFromUtf32(0x2998) `
			+ "   "
		$__color = "31"
		$__foreground_color = "Red"
	} "warning" {
		$__tag = [char]::ConvertFromUtf32(0x2997) `
			+ " WARNING " `
			+ [char]::ConvertFromUtf32(0x2998) `
			+ " "
		$__color = "33"
		$__foreground_color = "Yellow"
	} "info" {
		$__tag = [char]::ConvertFromUtf32(0x2997) `
			+ " INFO " `
			+ [char]::ConvertFromUtf32(0x2998) `
			+ "    "
		$__color = "36"
		$__foreground_color = "Cyan"
	} "note" {
		$__tag = [char]::ConvertFromUtf32(0x2997) `
			+ " NOTE " `
			+ [char]::ConvertFromUtf32(0x2998) `
			+ "    "
		$__color = "35"
		$__foreground_color = "Magenta"
	} "success" {
		$__tag = [char]::ConvertFromUtf32(0x2997) `
			+ " SUCCESS " `
			+ [char]::ConvertFromUtf32(0x2998) `
			+ " "
		$__color = "32"
		$__foreground_color = "Green"
	} "ok" {
		$__tag = [char]::ConvertFromUtf32(0x2997) `
			+ " OK " `
			+ [char]::ConvertFromUtf32(0x2998) `
			+ "      "
		$__color = "36"
		$__foreground_color = "Cyan"
	} "done" {
		$__tag = [char]::ConvertFromUtf32(0x2997) `
			+ " DONE " `
			+ [char]::ConvertFromUtf32(0x2998) `
			+ "    "
		$__color = "36"
		$__foreground_color = "Cyan"
	} "plain" {
		# do nothing
	} default {
		return
	}}

	if (($Host.UI.RawUI.ForegroundColor -ge "DarkGray") -or
		("$env:TERM" -eq "xterm-256color") -or
		("$env:COLORTERM" -eq "truecolor", "24bit")) {
		Write-Host `
			-ForegroundColor $__foreground_color `
			"$([char]0x1b)[1;${__color}m${__tag}$([char]0x1b)[0;${__color}m${__message}$([char]0x1b)[0m"
	} else {
		Write-Host "${__tag}${__message}"
	}

	Remove-Variable -Name __mode -ErrorAction SilentlyContinue
	Remove-Variable -Name __tag -ErrorAction SilentlyContinue
	Remove-Variable -Name __message -ErrorAction SilentlyContinue
	Remove-Variable -Name __color -ErrorAction SilentlyContinue
}
