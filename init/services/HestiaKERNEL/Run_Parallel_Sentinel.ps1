# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Error_Codes.ps1"




function HestiaKERNEL-Run-Parallel-Sentinel {
        param(
                [string]$____parallel_command,
                [string]$____parallel_control_directory,
                [string]$____parallel_available
        )


        # validate input
        if ($____parallel_command -eq "") {
                return ${env:HestiaKERNEL_ERROR_DATA_EMPTY}
        }

        if ($____parallel_control_directory -eq "") {
                return ${env:HestiaKERNEL_ERROR_ENTITY_EMPTY}
        }

        if (-not (Test-Path -PathType Container -Path $____parallel_control_directory)) {
                return ${env:HestiaKERNEL_ERROR_ENTITY_IS_NOT_DIRECTORY}
        }

        $____parallel_control = "${____parallel_control_directory}\control.txt"
        if (-not (Test-Path -PathType Leaf -Path $____parallel_control)) {
                return ${env:HestiaKERNEL_ERROR_ENTITY_INVALID}
        }

        try {
                if (
                        ($____parallel_available -eq "") -or
                        ($____parallel_available -le 0)
                ) {
                        $____parallel_available = [System.Environment]::ProcessorCount
                        if ($____parallel_available -le 0) {
                                $____parallel_available = 1
                        }
                }
        } catch {
                $____parallel_available = [System.Environment]::ProcessorCount
                if ($____parallel_available -le 0) {
                        $____parallel_available = 1
                }
        }


        # execute
        $____parallel_flags = "${____parallel_control_directory}\flags"
        $____parallel_total = 0


        # scan total tasks
        foreach ($____line in (Get-Content $____parallel_control)) {
                $____parallel_total += 1
        }


        # bail early if no task is available
        if ($____parallel_total -le 0) {
                return ${env:HestiaKERNEL_ERROR_OK}
        }


        # run in singular when only 1 task is required
        if (
                ($____parallel_available -le 1) -or
                ($____parallel_total -eq 1)
        ) {
                ${function:SYNC-Run} = $___parallel_command
                foreach ($____line in (Get-Content $____parallel_control)) {
                        $____process = SYNC-Run $____line
                        if ($____process -ne 0) {
                                return ${env:HestiaKERNEL_ERROR_BAD_EXEC}
                        }


                        # report status
                        return ${env:HestiaKERNEL_ERROR_OK}
                }
        }


        # run in parallel
        $____jobs = @()
        $____line_number = 0
        foreach ($____line in (Get-Content $____parallel_control)) {
                $____line_number += 1

                $____jobs += Start-ThreadJob -ScriptBlock {
                        $____parallel_flag = "${using:____parallel_flags}\l${using:____line_number}"


                        # secure parallel working lock
                        $null = New-Item -ItemType Directory `
                                        -Force `
                                        -Path "${____parallel_flag}_working"


                        # initiate parallel execution
                        ${function:SYNC-Run} = ${using:____parallel_command}
                        $____process = SYNC-Run ${using:____line}

                        try {
                                $null = Remove-Item `
                                                -Recurse `
                                                -Force `
                                                -Path "${____parallel_flag}_working"
                        } catch {
                                $____process = 1
                        }

                        switch ($____process) {
                        0 {
                                $null = New-Item -ItemType Directory `
                                                -Force `
                                                -Path "${____parallel_flag}_done"
                                return ${env:HestiaKERNEL_ERROR_OK}
                        } default {
                                $null = New-Item -ItemType Directory `
                                                -Force `
                                                -Path "${____parallel_flag}_error"
                                return ${env:HestiaKERNEL_ERROR_BAD_EXEC}
                        }}
                }
        }

        $null = Wait-Job -Job $____jobs
        foreach ($____job in $____jobs) {
                $____process = Receive-Job -Job $____job
                if ($____process -ne 0) {
                        return ${env:HestiaKERNEL_ERROR_BAD_EXEC}
                }
        }


        # report status
        return ${env:HestiaKERNEL_ERROR_OK}
}
