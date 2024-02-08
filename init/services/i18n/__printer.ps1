# BSD 3-Clause License
#
# Copyright (c) 2024 (Holloway) Chew, Kean Ho
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
function I18N-Status-Print {
	param(
		[string]$___mode,
		[string]$___message
	)


	# execute
	$___tag = I18N-Status-Tag-Get-Type "${___mode}"
	$___color = ""
	$___foreground_color = "Gray"
	switch ($___mode) {
	error {
		$___color = "31"
		$___foreground_color = "Red"
	} warning {
		$___color = "33"
		$___foreground_color = "Yellow"
	} info {
		$___color = "36"
		$___foreground_color = "Cyan"
	} note {
		$___color = "35"
		$___foreground_color = "Magenta"
	} success {
		$___color = "32"
		$___foreground_color = "Green"
	} ok {
		$___color = "36"
		$___foreground_color = "Cyan"
	} done {
		$___color = "36"
		$___foreground_color = "Cyan"
	} default {
		# do nothing
	}}

	if (($Host.UI.RawUI.ForegroundColor -ge "DarkGray") -or
		("$env:TERM" -eq "xterm-256color") -or
		("$env:COLORTERM" -eq "truecolor", "24bit")) {
		# terminal supports color mode
		if ((-not ([string]::IsNullOrEmpty($___color))) -and
			(-not ([string]::IsNullOrEmpty($___foreground_color)))) {
			$null = Write-Host `
				-NoNewLine `
				-ForegroundColor $___foreground_color `
				"$([char]0x1b)[1;${___color}m${___tag}$([char]0x1b)[0;${___color}m${___message}$([char]0x1b)[0m"
		} else {
			$null = Write-Host -NoNewLine "${___tag}${___message}"
		}
	} else {
		$null = Write-Host -NoNewLine "${___tag}${___message}"
	}

	$null = Remove-Variable -Name ___mode -ErrorAction SilentlyContinue
	$null = Remove-Variable -Name ___tag -ErrorAction SilentlyContinue
	$null = Remove-Variable -Name ___message -ErrorAction SilentlyContinue
	$null = Remove-Variable -Name ___color -ErrorAction SilentlyContinue
	$null = Remove-Variable -Name ___foreground_color -ErrorAction SilentlyContinue


	# report status
	return 0
}




function I18N-Status-Tag-Create {
	param(
		[string]$___content,
		[string]$___spacing
	)


	# validate input
	if ($(STRINGS-Is-Empty "${___content}") -eq 0) {
		return ""
	}


	# execute
	return "⦗${___content}⦘${___spacing}"
}




function I18N-Status-Tag-Get-Type {
	param(
		[string]$___mode
	)


	# execute
	switch (${env:UPSCALER_LANG}) {
	{ $_ -in "DE", "de" } {
		return I18N-Status-Tag-Get-Type-DE "${___mode}"
	}
	default {
		return I18N-Status-Tag-Get-Type-EN "${___mode}"
	}}
}




function I18N-Status-Tag-Get-Type-EN {
	param(
		[string]$___mode
	)


	# execute (REMEMBER: make sure the text and spacing are having the same length)
	switch ($___mode) {
	error {
		return I18N-Status-Tag-Create " ERROR " "   "
	} warning {
		return I18N-Status-Tag-Create " WARNING " " "
	} info {
		return I18N-Status-Tag-Create " INFO " "    "
	} note {
		return I18N-Status-Tag-Create " NOTE " "    "
	} success {
		return I18N-Status-Tag-Create " SUCCESS " " "
	} ok {
		return I18N-Status-Tag-Create " OK " "      "
	} done {
		return I18N-Status-Tag-Create " DONE " "    "
	} default {
		return ""
	}}
}




function I18N-Status-Tag-Get-Type-DE {
	param(
		[string]$___mode
	)


	# execute (REMEMBER: make sure the text and spacing are having the same length)
	switch ($___mode) {
	error {
		return I18N-Status-Tag-Create " FEHLER " "    "
	} warning {
		return I18N-Status-Tag-Create " WARNUNG " "   "
	} info {
		return I18N-Status-Tag-Create " INFO " "      "
	} note {
		return I18N-Status-Tag-Create " ANMERKUNG " " "
	} success {
		return I18N-Status-Tag-Create " ERFOLG " "    "
	} ok {
		return I18N-Status-Tag-Create " OKAY " "      "
	} done {
		return I18N-Status-Tag-Create " FERTIG " "    "
	} default {
		return ""
	}}
}
