# Holloway's Upscaler - Image & Video
[![Holloway's Upscaler](artworks/logo-1200x630.svg)](https://github.com/hollowaykeanho/Upscaler)
This project is a consolidation of various compiled open-source AI image/video
upscaling product for a working CLI friendly image and video upscaling program.




## Why It Matters
For these reasons:

1. **Low-cost image/video AI upscaling software** - run locally in your laptop
   with an AI solution.
2. **Programmable** - when you upscale an album or a video, the AI program has
   to be programmable and not restricted by any GUI's design.
3. **Reliabily working on big subject** - video files are usually large and
   require streaming algorithm approach for preventing uncontrollable
   resources consumption for a simple OS system (e.g. disk space, RAM, and
   vRAM).
4. **I urgently need a video upscaling technologies to work locally** -
   for both image and video without any GUI overheads.



### Contributors
This repository was made possible by the following contributors:

1. [Joly0](https://github.com/Joly0) - Windows support via PowerShell.
2. [Cory Galyna](https://github.com/corygalyna) - Repository & CI management.
3. [Jean Shuralyov](https://github.com/JeanShuralyov) - Documentations.
4. [(Holloway) Chew, Kean Ho](https://github.com/hollowaykeanho) - FFMPEG & UNIX Support via POSIX Shell and Polygot Script.




## Supported Hardware
Here are the tested hardware and operating system:

| System             | Results     | Usable Processing Units |
|:-------------------|:------------|:------------------------|
| `debian-amd64` (linux) | `PASS`      | `NVIDIA GeForce MX150`, `Intel(R) UHD Graphics 620 (KBL GT2)` |
| `darwin-amd64` (macOS) | `FAILED`    | Binary failed to use `Intel Iris Graphics` iGPU and CPU. |
| `windows-amd64` (windows) | `TBD`    | **Help Needed** - pending benchmark results from `tests/benchmark.cmd` |

> **IMPORTANT NOTES**
>
> (1)
>
> You seriously need a compatible GPU to drastically speed up the upscaling
> efforts **from hours to seconds** for image. I tested mine against
> `NVIDIA GeForce MX150` vs. `Intel(R) UHD Graphics 620 (KBL GT2)` built-in
> graphic hardwares in my laptop. It did a huge difference.
>
> (2)
>
> At the moment, the algorithm only works on constant bit rate video. Variable
> bit rate (VBR) video are considered but may be done in the future with proper
> programming language. Most (as in 99% of video) are constant bit rate video
> so VBR support is at least concern.
>
> (3)
>
> Not all images can be upscaled (e.g. some AI generated images from Stable
> Diffussion) due to the binary's internal image decoder bug. Tracking issue:
> https://github.com/xinntao/Real-ESRGAN/issues/595
>
> (4)
>
> Re-packaging efforts are unlikely because currently it's a bad investment.
> It's either I spend the time study NCNN implementations and write the whole
> XinTao's RealESRGAN-Vulcan program as my own codes from scratch or glued the
> existing programs together. At the moment, I do not have the resources to rewrite
> or study the NCNN (yet).


> **NOTE TO MacOS USERS**
>
> The binary `bin/mac-amd64` is currently unsigned. Hence, you need to explictly
> grant the use permission in your `Settings > Security & Privacy` section.
>
> Please be informed that my test result is in accordance with the Upscayl team:
> many CPU and iGPUs are not working and supported yet.



### Dependencies
If you're working on video, you need `ffmpeg` and `ffprobe` for dissecting and
reassembling a video file.

You can proceed to install them in 1 go at: https://ffmpeg.org/




## User Manual
Here are the basic user manuals:



### Install
There are different ways of installing this program depending on your interested
versions:


#### `>= v0.6.0`
You can download the latest version of the `upscaler-[VERSION].zip`
package from https://github.com/hollowaykeanho/Upscaler/releases
and unzip it to an appropriate version. Note that the models are already
included in this package.

For those who wants to just update the models, the
`upscaler-models-[VERSION].zip` is made available for you. Simply overwrite
the `models/` directory's contents in the software.

For those who wants to run test and benchmarks for the repository, the
`upscaler-tests-[VERSION].zip` is made available for you. Simply integrate
the `tests/` directory into your existing software program.


#### `< v0.6.0`
You need to `git clone` the repository into an appropriate location.

```
$ git clone https://github.com/hollowaykeanho/Upscaler.git
```


### Setup Pathing for Command [OPTIONAL, 1-Time]
We advise you to symlink the `start.cmd` into `$PATH` or `%PATH%` directory
depending on your operating system. Example, on `Debian Linux`:

```
$ ln -s /path/to/Upscaler/start.cmd /path/to/bin/upscaler
```

Alternatively, on UNIX (Linux & Mac) systems, you can create a shell script that
pass all arguments into the `start.cmd`. Example:

```
#!/bin/sh
/path/to/Upscaler/start.cmd "$@"
```

> TIP: if had you decided to use the shell script approach, you can also design
> the command to use your default model and scaling for your programming
> efficiencies. Recommend you use `$HOME/bin` directory if it is set visible in
> your `$PATH` value.



### Call for Help
This repository was unified using
[Holloway's Polygot Script](https://github.com/hollowaykeanho/PolygotScript) to
keep user instruction extremely simple. Hence, in any operating system (UNIX or
WINDOWS), simply interact with the repository's `start.cmd` script will do.
Example for requesting a help instruction:

```
$ ./Upscaler/start.cmd --help
```

In the help display, you generally want to take notice of the `AVAILABLE MODELS`
list. The upscaling algorithms are solely based on the available models in the
[models](https://github.com/hollowaykeanho/Upscaler/tree/main/models) directory.
The scripts are written in a way to dynamically index each of them and present
it in the help display without re-writing itself.



### Upscale an Image
To upscale an image simple run `start.cmd` against the image:

```
$ ./start.cmd \
        --model ultrasharp \
        --scale 4 \
        --format webp \
        --input my-image.jpg
```

To determine the available models, their respective scale limits, and output
formats, simple execute the `--help` and look for: `AVAILABLE MODELS` and
`AVAILABLE FORMATS` respectively.

If done correctly, an image based on orginal filename with a suffix `-upscaled`
is created. If we follow the example above, it should be
`my-image-upscaled.webp`.



### Upscale a Video
Unless you're working on 8 seconds 8MB sized video, you would want to follow the
instructions below to make sure your project are always in-tact and resumeable.


#### (1) Budget Your Hardware Storage
Please keep in mind that **you need at least 3x video size storage** for
the job depending on the video frame rate, frame size, color schemes and etc.
The minimum 3x is due to:

1. 1 set is your original video.
2. 1 set is for all the upscaled images (can be lot bigger since we're doing it
   frame by frame losing the video compression effect).
3. 1 set is your output video (bigger than original of course).

Hence, please plan out your storage budget before starting a video upscaling
project.

> **IMPORTANT**
>
> **Know your hardware limitations** before determining the scaling factor. A
> scale of 4x on a 1090p for a 12GB memory laptop can crash the entire OS (I'm
> talking about the very stable Debian OS) during the video re-assembly phase
> with FFMPEG due to memory starvation.


#### (2) Setup Project Directory
You're advised to create a project directory for upscaling video project due to
its large sized data.

Instead of executing the `start.cmd` straight away, please script it inside and
place it in a project directory.

A simple UNIX example would be a shell script (e.g. `run.sh`) as follows:

```
#!/bin/sh
/path/to/Upscaler/start.cmd --model ultrasharp \
	--scale 4 \
	--input ./sample-vid.mp4 \
	--video
```

A simple WINDOWS example would be a batch script (e.g. `run.bat`) as follows:

```
@echo off
/path/to/Upscaler/start.cmd --model ultrasharp ^
	--scale 4 ^
	--input ./sample-vid.mp4 ^
	--video
```

This is for resuming the upscaling project in case of crashes or long hours
work. A good directory looks something as follows:

```
/path/to/my-upscaled-project/
├── run.sh
└── sample-vid.mp4
```


#### (3) Run The Initator Script
To initiate or to resume project, simply run your initiated project:

```
# cd /path/to/my-upscaled-project
$ ./run.sh
```

The Upscaler will create a workspace to house its output frames and control
values. You can inspect the frame images while Upscaler is at work as long as
you're viewing the frame that it is working on.

I recommend you inpect the frames first for determining whether the AI model is
suitable or otherwise. If it's not, please stop the process and execute the next
step.


#### (4) Resetting the Project [JUST IN CASE]
Just in case if you bump into something odd that requires to restart the project
from start, you can delete the `[FILENAME]-workspace` directory inside the
project directory. This will force the program to restart everything all over
again.

The project intentionally left the workspace as it is for those who want to
do frame extractions for other purposes (e.g. getting thumbnail).




## Helping The Project
Star, Watch, or the best: **sponsor the contributors**.



### Contribute Back
In case you need to contribute back:

1. Raise an [issue ticket](https://github.com/hollowaykeanho/Upscaler/issues).
2. Fork the repository and work against the `main` branch.
3. Develop your contributions and ensure your commit are GPG-signed.
4. Once done, **DO NOT raise a pull request unless instructed**. Simply notify
   me via your ticket and I will clone your forked repo locally and
   `cherry-pick` them (I need those GPG signatures preserved where GitHub Pull
   Request cannot fulfill). An exception would be the you have a need to earn
   the
   [GitHub Pair Extraordinaire Badge](https://github.blog/2018-01-29-commit-together-with-co-authors/).
   For doing that, please add me into your forked repo and I will make it happen
   for you.
5. Delete your fork repo once I notify you that the merging is completed.
6. Thank you.



### Benchmarks
Results of benchmarks running `tests/benchmark.sh` at the root of the
repository. Please leave the system dedicated to only running the benchmark
and not doing something else for maintaining results consistencies. These
benchmarks serve 2 purposes:

1. To test the repository's programs are running properly for both video and
   image upscaling.
2. To identify what platform, OS, and hardware capable of running this project.
   (good for determining usability before procurement).
3. To know about its statistical performances.



### Debian AMD64 CPU, 12GB Memory, 2GB VRAM, NVIDIA GeForce MX150

| Version     | Sample 1 (Video)                                           |
|:------------|:-----------------------------------------------------------|
| `v0.5.0`    | `(real) 153m12.182s (user) 178m30.323s (sys) 18m29.955s`   |
|`v0.4.0`     | `(real) 171m56.165s (user) 257m51.602s (sys) 19m24.107s`   |
|`v0.3.0`     | `TBD`   |
|`v0.2.0`     | `TBD`   |
|`v0.1.0`     | `TBD`   |




## Upstream and Source Codes
This is a binaries assembled repository. You may find the source codes from the
original contributors here:

1. [Tencent's NCNN](https://github.com/Tencent/ncnn)
2. [Nihui](https://github.com/nihui)
3. [Xintao](https://github.com/xinntao)
4. [Upscayl (Nayam Amarshe & TGS963)](https://github.com/upscayl/upscayl/tree/main)

Test sample video in the `tests/` directory was supplied by
[Igrid North](https://www.pexels.com/video/the-sun-illuminating-earth-s-surface-1851190/)
from
[Pexels](https://www.pexels.com/). Original 4k sized video is also available at
origin for upscaling comparison.




## License
This project is aligned to its upstream sources and is licensed under
[BSD-3-Clause "New or "Revised" License](LICENSE.txt).
