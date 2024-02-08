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




# To use:
#   $ SYNC-Exec-Parallel ${function:Function-Name}.ToString() `
#                          "$(Get-Location)\control.txt" `
#                          ".\tmp\parallel" `
#                          "$([System.Environment]::ProcessorCount)"
#
#   The subroutine function accepts a wrapper function as shown above. Here is
#   an example to construct a simple parallelism executions:
#       function Function-Name {
#               param (
#                       [string]$___line
#               )
#
#
#               # initialize and import libraries from scratch
#               ...
#
#
#               # break line into multiple parameters (delimiter = '|')
#               $___list = $___line -split "\|"
#               $___arg1 = $___list[1]
#               $___arg2 = $___list[2]
#               ...
#
#
#
#               # some tasks in your thread
#               ...
#
#
#               # execute
#               ...
#
#
#               # report status
#               return 0 # signal a successful execution
#       }
#
#
#       # calling the parallel exec function
#       SYNC-Exec-Parallel ${function:Function-Name}.ToString() `
#                          "$(Get-Location)\control.txt" `
#                          ".\tmp\parallel" `
#                          "$([System.Environment]::ProcessorCount)"
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
function SYNC-Exec-Parallel {
	param(
		[string]$___parallel_command,
		[string]$___parallel_control,
		[string]$___parallel_directory,
		[string]$___parallel_available
	)


	# validate input
	if ([string]::IsNullOrEmpty($___parallel_command)) {
		return 1
	}

	if ([string]::IsNullOrEmpty($___parallel_control) -or
		(-not (Test-Path -Path "${___parallel_control}"))) {
		return 1
	}

	if ([string]::IsNullOrEmpty($___parallel_available)) {
		$___parallel_available = [System.Environment]::ProcessorCount
	}

	if ($___parallel_available -le 0) {
		$___parallel_available = 1
	}

	if ([string]::IsNullOrEmpty($___parallel_directory)) {
		$___parallel_directory = Split-Path -Path "${___parallel_control}" -Parent
	}

	if (-not (Test-Path -Path "${___parallel_directory}" -PathType Container)) {
		return 1
	}


	# execute
	$___parallel_directory = "${___parallel_directory}\flags"
	$___parallel_total = 0


	# scan total tasks
	foreach ($___line in (Get-Content "${___parallel_control}")) {
		$___parallel_total += 1
	}


	# end the execution if no task is available
	if ($___parallel_total -le 0) {
		return 0
	}


	# run singularly when parallelism is unavailable or has only 1 task
	if (($___parallel_available -le 1) -or ($___parallel_total -eq 1)) {
		# prepare
		${function:SYNC-Run} = ${___parallel_command}


		# execute
		foreach ($___line in (Get-Content "${___parallel_control}")) {
			$___process = SYNC-Run "${___line}"
			if ($___process -ne 0) {
				return 1
			}
		}


		# report status
		return 0
	}


	# run in parallel
	$___jobs = @()
	foreach ($___line in (Get-Content "${___parallel_control}")) {
		$___jobs += Start-ThreadJob -ScriptBlock {
			# prepare
			${function:SYNC-Run} = ${using:___parallel_command}


			# execute
			$___process = SYNC-Run "${using:___line}"
			if ($___process -ne 0) {
				return 1
			}


			# report status
			return 0
		}
	}

	$null = Wait-Job -Job $___jobs
	foreach ($___job in $___jobs) {
		$___process = Receive-Job -Job $___job
		if ($___process -ne 0) {
			return 1
		}
	}


	# report status
	return 0
}




# To use:
#   $ SYNC-Exec-Serial ${function:Function-Name}.ToString() "$(Get-Location)\control.txt"
#
#   The subroutine function accepts a wrapper function as shown above. Here is
#   an example to construct a simple parallelism executions:
#       function Function-Name {
#               param (
#                       [string]$___line
#               )
#
#
#               # initialize and import libraries from scratch
#               ...
#
#
#               # break line into multiple parameters (delimiter = '|')
#               $___list = $___line -split "\|"
#               $___arg1 = $___list[1]
#               $___arg2 = $___list[2]
#               ...
#
#
#               # some tasks in your thread
#               ...
#
#
#               # execute
#               ...
#
#
#               # report status
#               return 0 # signal a successful execution
#       }
#
#
#       # calling the parallel exec function
#       SYNC-Exec-Serial ${function:Function-Name}.ToString() "$(Get-Location)\control.txt"
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
function SYNC-Exec-Serial {
	param(
		[string]$___serial_command,
		[string]$___serial_control
	)


	# validate input
	if ([string]::IsNullOrEmpty($___serial_command)) {
		return 1
	}

	if ([string]::IsNullOrEmpty($___serial_control) -or
		(-not (Test-Path -Path "${___serial_control}"))) {
		return 1
	}


	# execute
	${function:SYNC-Run} = ${___serial_command}
	foreach ($___line in (Get-Content "${___serial_control}")) {
		$___process = SYNC-Run "${___line}"
		if ($___process -ne 0) {
			return 1
		}
	}


	# report status
	return 0
}
