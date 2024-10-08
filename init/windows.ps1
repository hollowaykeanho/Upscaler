# Copyright (c) 2023, (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
# Copyright (c) 2023, Joly0 (https://github.com/Joly0)
#
#
# BSD 3-Clause License
#
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
Param (
    [String]$model,
    [String]$scale,
    [int]$parallel = 1,
    [String]$format,
    [String]$path,
    [switch]$video,
    [String]$output,
    [String]$action = "run",
    [switch]$help
)

$program = ""
$model_id = ""
$model_name = ""
$model_max_scale = ""
$subject_name = ""
$subject_ext = ""
$subject_dir = ""
$subject_suffix = "upscaled"
$workspace = ""

[hashtable] $modeldetails = @{}

$repo = (Get-Item $PSScriptRoot).Parent.FullName
function Get-AvailableModels {
    Write-Host "Available Models:" -ForegroundColor Yellow
    foreach ($model_type in Get-ChildItem -Path "$repo\models" -Filter *.sh) {
        $model_type.BaseName
    }
}

function Test-Program {
    if (Test-Path -Path "$repo\bin\windows-amd64.exe") {
        $script:program = "$repo\bin\windows-amd64.exe"
        return $true
    }

    return $false
}

function Test-Model {
    if ( [string]::IsNullOrEmpty($model) ) {
        Write-Host "Unspecified model" $model -ForegroundColor Red
        return $false
    }

    if (-not (Test-Path -Path "$repo\models") ) {
        Write-Host "$repo\models folder not found" -ForegroundColor Red
        return $false
    }

    return $true
}

function Get-ModelInformation {
    foreach ($model_type in Get-ChildItem -Path "$repo\models" -Filter *.sh) {
        $model_id = $model_type.Name -replace '\.sh$'
        if ($model -eq $model_id) {
            $modelvariables = Get-Content "$($model_type.FullName)"
            [hashtable] $modeldetails = @{}
            foreach ($line in $modelvariables) {
                if ($line.Substring(0, 1) -match "[A-Za-z]") {
                    $pos = $line.IndexOf("=")
                    $leftPart = ($line.Substring(0, $pos)).Trim()
                    $rightPart = (($line.Substring($pos+1)).Trim()).Trim('"')
                    $modeldetails.Add($leftPart, $rightPart)
                }
            }
            return $modeldetails
        }
    }

    Write-Host "Unsupported model:" $model -ForegroundColor Red
    Exit
}

function Get-Scale($model_max_scale) {
    if ( [string]::IsNullOrEmpty($scale) ) {
        Write-Host "Unspecified scaling factor" -ForegroundColor Red
        return $false
    }

    if ( ($model_max_scale -eq 0) -and ($scale -gt 1) ) {
        return $true
    } else {
        Write-Host "Bad scale:" $scale -ForegroundColor Red
        return $false
    }

    if ($scale -gt $model_max_scale) {
        Write-Host "Scale is too big:" $scale "/" $model_max_scale -ForegroundColor Red
        return $false
    }

    return $true
}

function Get-Format {
    if ( [string]::IsNullOrEmpty($format) ) {
        if ($video) {
            $script:format = "png"
        } else {
            $script:format = $path.Substring($path.LastIndexOf('.') + 1)
        }
    }

    switch ($format.ToLower()) {
        'jpg' {
            $format = 'jpg'
            return $true
        }
        'png' {
            $format = 'png'
            return $true
        }
        'webp' {
            $format = 'webp'
            return $true
        }
        default {
            Write-Host "Unsupported output format:" $format -ForegroundColor Red
            return $false
        }
    }
}

function Get-Parallel() {
    if ( [string]::IsNullOrEmpty($parallel) ) {
        Write-Host "Unspecified parallel value" -ForegroundColor Red
        return $false
    }

    if ( $parallel -ge 1 ) {
        return $true
    } else {
        Write-Host "Bad parallel value:" $parallel -ForegroundColor Red
        return $false
    }

    return $true
}

function Get-IO {
    if ( [string]::IsNullOrEmpty($path) ) {
        Write-Host "Unspecified input path" -ForegroundColor Red
        return $false
    }

    if (-not (Test-Path -Path $path) ) {
        Write-Host "Input does not exist:" $path -ForegroundColor Red
        return $false
    }

    Set-Variable -Scope 1 -Name "path" -Value $(Resolve-Path -Path $path)

    if ($video) {
        if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue) ) {
            Write-Host "Missing required ffmpeg program for video." -ForegroundColor Red
            return $false
        }

        if (-not (Get-Command ffprobe -ErrorAction SilentlyContinue) ) {
            Write-Host "Missing required ffprobe program for video." -ForegroundColor Red
            return $false
        }
    }

    return $true
}

function Invoke-Upscale($input_path, $output_path, $frameNumber, $failedFrames) {
    $params = "-i `"$input_path`" -o `"$output_path`" -s $scale -m `"$repo\models`" -n $model -f $format"
    $process = Start-Process -FilePath $program -ArgumentList $params -Wait -PassThru -WindowStyle Minimized

    if ($process.ExitCode -ne 0) {
        $errorMessage = "Error occurred during upscaling. Exit code: $($process.ExitCode). Input: $input_path, Output: $output_path"
        Write-Host $errorMessage -ForegroundColor Red

        # Log the error to a file
        $errorMessage | Out-File -FilePath "$workspace\error_log.txt" -Append

        # Add the failed frame number to the concurrent bag
        $failedFrames.Add($frameNumber)

        # Return false to indicate an error occurred
        return $false
    }

    return $true
}

function Invoke-Program {
    $output_format = $format
    if ($video) {
        $output_format = $subject_ext
    }

    if ($model_max_scale -eq 0 ) {
        $model_max_scale = "unspecified"
    }

    Write-Host "Upscale Model:      " $model
    Write-Host "Upscale Scale:      " $scale
    Write-Host "Upscale Max Scale: " $model_max_scale
    Write-Host "Upscale Format:     " $format
    Write-Host "Input File:     " $path
    if ($video) {
        Write-Host "Is Video Input:      Yes"
    } else {
        Write-Host "Is Video Input:      No"
    }
    Write-Host ""
    Write-Host "Output Directory:   " $subject_dir
    Write-Host "Output Filename:    " $subject_name
    Write-Host "Output Suffix:      " $subject_suffix
    Write-Host "Output Extension:   " $output_format
    Write-Host ""


    if (-not ($video) ) {
        $script:output = $subject_dir + "\" + $subject_name + "-" + $subject_suffix + "." + $output_format
        if (-not (Invoke-Upscale -input_path $path -output_path $output) ) {
            Write-Host "Error" -ForegroundColor Red
            Exit
        }

        Write-Host "Success" -ForegroundColor Green
        Exit
    }

    $script:workspace = $subject_dir + "\" + $subject_name + "-" + $subject_suffix + "_" + "workspace"
    $control = Join-Path $workspace "control.ps1"
    $control = $control.Trim()


    $video_codec = ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$path" 2>&1
    $audio_codec = ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$path" 2>&1
    $frame_rate = ffprobe -v error -select_streams v -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$path" 2>&1
    $total_frames = ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -of default=noprint_wrappers=1:nokey=1 "$path" 2>&1
    $input_frame_size = ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$path" 2>&1

    $pixel_format = ""
    $output_frame_size = ""
    $current_frame  = 1

    if (Test-Path -LiteralPath $control) {
        Write-Host "Found control file $control. Restoring..."
        Write-Host ""
        . $control
    } else {
        Write-Host "Creating workspace..."
        Write-Host ""
        if (Test-Path $workspace) {
            Remove-Item -Path $workspace -Recurse -Force
        }
        New-Item -Path $workspace -ItemType directory
    }

    if ($current_frame -gt $total_frames) {
        $current_frame = $total_frames
    }

    Write-Host "Video Name:     " "$subject_name.$subject_ext"
    Write-Host "Video Codec:        " $video_codec
    Write-Host "Audio Codec:        " $audio_codec
    Write-Host "Pixel Format:       " $pixel_format "(empty means yet to determine)"
    Write-Host "Input Frame:        " $input_frame_size
    Write-Host "Output Frame:       " $output_frame_size "(empty means yet to determine)"
    Write-Host ""
    Write-Host "Frame Rate:         " $frame_rate
    Write-Host "Total Frames:       " $total_frames
    Write-Host "Current Frame:      " $current_frame
    Write-Host ""

    $InvokeUpscaleDef = ${function:Invoke-Upscale}.ToString()
    $failedFrames = [System.Collections.Concurrent.ConcurrentBag[int]]::new()

    $current_frame..$total_frames | ForEach-Object -Parallel {
        ${function:Invoke-Upscale} = $using:InvokeUpscaleDef
        $total_frames =  $using:total_frames
        $workspace = $using:workspace
        $format = $using:format
        $path = $using:path
        $program = $using:program
        $control = $using:control
        $pixel_format = $using:pixel_format
        $output_frame_size = $using:output_frame_size
        $failedFrames = $using:failedFrames
        $repo = $using:repo
        $model = $using:model
        $scale = $using:scale
        $frame_rate = $using:frame_rate
        $video_codec = $using:video_codec
        $audio_codec = $using:audio_codec
        $input_frame_size = $using:input_frame_size
        $control = $using:control

        Write-Host "Upscaling frame" "$_/$total_frames"
        $img = "$workspace" + "\" + "0" + $_ + "sample." + $format
        ffmpeg -y -thread_queue_size 4096 -i "$path" -vf select="eq(n\,$_)" -vframes 1 $img 2> $null

        $output = $workspace + "\" + "frame" + "\" + "0" + $_ + "." + $format
        $result = Invoke-Upscale -input_path $img -output_path $output -frameNumber $_ -failedFrames $failedFrames
        if (-not $result) {
            Write-Host "Error occurred while processing frame $_. Check error_log.txt for details." -ForegroundColor Yellow
        }

        if ([string]::IsNullOrEmpty($pixel_format)) {
            $pixel_format = ffprobe -loglevel error -show_entries stream=pix_fmt -of csv=p=0 "$output" 2>&1
        }
        if ([string]::IsNullOrEmpty($output_frame_size)) {
            $output_frame_size = ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$output" 2>&1
        }
        Remove-Item -Path $img -Force

        $mutex = New-Object System.Threading.Mutex $false, "ControlFileMutex"

        # Synchronize file access
        $mutex.WaitOne()
        try {
            # Check if control file exists before trying to read it
            if (Test-Path -Path $control) {
                $control_content = Get-Content -Path $control -Raw

                # Extract the existing $current_frame value from the control file
                $existing_frame_match = $control_content -match '`$current_frame = "(\d+)"'
                $existing_frame = if ($existing_frame_match) { [int]$matches[1] } else { 0 }
            } else {
                # If the file doesn't exist, initialize $existing_frame to 0
                $existing_frame = 0
            }

            # Update only if the new frame is larger than the existing one
            if ($_ -gt $existing_frame) {
                $current_frame = $_+1
                $control_output = "`$total_frames = $total_frames" + "`r`n"
                $control_output += "`$current_frame = $current_frame" + "`r`n"
                $control_output += "`$pixel_format = `"$pixel_format`"" + "`r`n"
                $control_output += "`$frame_rate = `"$frame_rate`"" + "`r`n"
                $control_output += "`$video_codec = `"$video_codec`"" + "`r`n"
                $control_output += "`$audio_codec = `"$audio_codec`"" + "`r`n"
                $control_output += "`$input_frame_size = `"$input_frame_size`"" + "`r`n"
                $control_output += "`$output_frame_size = `"$output_frame_size`""
                $control_output | Out-File -FilePath $control -NoNewline
            }
        } finally {
            $mutex.ReleaseMutex()
        }
    } -ThrottleLimit $parallel

    if ($failedFrames.Count -gt 0) {
        Write-Host "The following frames failed to process: $($failedFrames -join ', ')" -ForegroundColor Red
        $choice = Read-Host "Do you want to (R)etry failed frames, or (C)ontinue? [R/C]"

        if ($choice -eq "R") {
            foreach ($frame in $failedFrames) {
                Write-Host "Retrying frame $frame" -ForegroundColor Yellow
                # Call your frame processing logic here for the failed frame
                # You might need to adjust paths and variables as necessary
                Invoke-Upscale -input_path $frame -output_path $output
            }
        }
        else {
            Write-Host "Continuing without retrying failed frames." -ForegroundColor Yellow
        }
    }

    $script:output = $subject_dir + "/" + $subject_name + "-" + $subject_suffix + "." + $subject_ext
    ffmpeg -y `
            -thread_queue_size 4096 `
            -i "$path" `
            -r $frame_rate `
            -thread_queue_size 4096 `
            -i "$workspace\frame\0%d.$format" `
            -c:v $video_codec `
            -pix_fmt $pixel_format `
            -r $frame_rate `
            -filter_complex "[0:v:0]scale=$output_frame_size[v0];[v0][1]overlay=eof_action=pass" `
            -c:a copy `
            "$output"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success" -ForegroundColor Green
        return $true
    }
}




if ( ([string]::IsNullOrEmpty($model)) -and ([string]::IsNullOrEmpty($scale)) -and ([string]::IsNullOrEmpty($format)) -and ([string]::IsNullOrEmpty($path)) -and ([string]::IsNullOrEmpty($output)) ) {
    Powershell.exe -NoProfile -Command "Get-Help $PSScriptRoot\windows.ps1"
    Get-AvailableModels
    Exit
}

if ($help) {
    Powershell.exe -NoProfile -Command "Get-Help $PSScriptRoot\windows.ps1 -full"
    Get-AvailableModels
    Exit
}

if (-not (Test-Program) ) {
    Write-Output "Missing AI executable: $repo\bin\windows-amd64.exe" -ForegroundColor Red
    Exit
}

if (-not (Test-Model) ) {
    Exit
}
$modeldetails = Get-ModelInformation

if (-not (Get-Scale -model_max_scale $modeldetails.Model_Max_Scale) ) {
    Exit
}

if (-not (Get-Format) ) {
    Exit
}

if (-not (Get-Parallel) ) {
    Exit
}

if (-not (Get-IO) ) {
    Exit
} else {
    $subject_name = Split-Path $path -Leaf
    $subject_dir = Split-Path $path -Parent
    $subject_ext = $subject_name -split "\." | Select-Object -Last 1
    $subject_name = $subject_name -replace "\.$subject_ext", ""
}

if (-not (Invoke-Program) ) {
    Exit
}
