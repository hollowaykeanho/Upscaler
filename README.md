# Holloway's Upscaler
[![Holloway's Upscaler](artworks/logo-1200x630.svg)](https://github.com/hollowaykeanho/Upscaler)
This project is a combination of various compiled open-source AI image upscaling
project efforts for making a working CLI friendly image upscaler program that
can be used for image and video subjects with FFMPEG.




## Why It Matters
For these reasons:

1. **I urgently need a video upscaling technologies to work locally** -
   that works on image and video without GUI overheads and its funkiness.
2. **Programmable** - when you want to upscale the an album or video, the AI
   program has to be programmable and not restricted to the GUI's design.
3. **Reliabily working on big subject** - larger video requires streaming
   approach to prevent the program from consuming too much resources from the
   system.




## Source Codes
This is a binaries assembled repository. You may find the source codes from the
original contributors here:

1. [Tencent's NCNN](https://github.com/Tencent/ncnn)
2. [Nihui](https://github.com/nihui)
3. [Xintao](https://github.com/xinntao)
4. [Upscayl (Nayam Amarshe & TGS963)](https://github.com/upscayl/upscayl/tree/main)




## License
This project is licensed under
[BSD-3-Clause "New or "Revised" License](LICENSE.txt).




## Supported Hardware
Here are the tested hardware and operating system:

1. `Linux` - tested and operated on Debian `amd64`.
2. `Windows` - HELP NEEDED to either translate `init/unix.sh` or somewhat
               support PowerShell. Latter is preferred if PowerShell complies to
               POSIX shell script.
3. `MacOS` - HELP NEEDED to test the repository. Assume it only works on
             `amd64`.

> **IMPORTANT NOTE**
>
> You seriously need a GPU to dramatically speed up the upscaling efforts from
> hours to minutes. I tested mine against `NVIDIA GeForce MX150` versus the
> built-in `Intel(R) UHD Graphics 620 (KBL GT2)` graphic hardwares. It makes a
> lot of difference.


### Dependencies
If you're working on video, you need `ffmpeg` and `ffprobe` for dissecting and
reassembling a video file.

You can proceed to install it at: https://ffmpeg.org/




## User Manual
Here are the basic user manuals:


### Install
At the moment, I'm not planning to re-package the products. Besides, it's
specifically designed for CLI interfacing. Hence, to install, simply `git clone`
the repository into an appropriate location and symlink to your `$PATH` or
`%PATH%` directory. Example, on `Debian Linux`:

```
$ git clone https://github.com/hollowaykeanho/Upscaler.git
$ ln -s /path/to/Upscaler/start.cmd /path/to/bin/upscaler
```

Alternatively, on UNIX (Linux & Mac) systems, you can create a shell script that
pass all arguments into the `start.cmd`. Example:

```
#!/bin/sh
/path/to/Upscaler/start.cmd $@
```

> TIP: if you decided to use the shell script approach, you can also design the
> command to use your default model and scaling for your programming
> efficiencies. Recommend you use `$HOME/bin` directory if it is shown in your
> `$PATH` value.

> NOTE:
>
> Re-packaging efforts are unlikely because it's a bad investment. It's either
> I spend the time study NCNN implementations and write the whole XinTao's
> RealESRGAN-Vulcan program as my own codes or glued the existing programs
> together with POSIX compliant shell script. At the moment, I do not have the
> resources to rewrite or study the NCNN.


### Call for Help
This repository was unified using
[Holloway's Polygot Script](https://github.com/hollowaykeanho/PolygotScript) to
keep user instruction extremely simple. Hence, in any operating system (UNIX or
WINDOWS), simply interact with the repository's `start.cmd` script will do.
Example for, instruction on Linux or MacOS

```
$ ./Upscaler/start.cmd --help
```

In help display, you generally want to take notice of the `AVAILABLE MODELS`
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
is created. If we follow the example above, it should b
 `my-image-upscaled.webp`.


### Upscale a Video
Unless you're working on 8 seconds 8MB sized video, you would want to follow the
instructions below to make sure your video upscaling project are in tact and
resumeable.

#### Budget Your Storage
Also please keep in mind that **you need at least 3x video size storage** for
the job depending on the video frame rate, frame size, color schemes and etc.
The minimum 3x is due to:

1. 1 set is your original video.
2. 1 set is for all the upscaled images (can be lot bigger since we're doing it
   frame by frame losing the video compression effect).
3. 1 set is your output video

Hence, please plan out your storage budget before proceeding to upscale a video.

#### Setup Project Directory
You're advised to create a project directory for upscaling video project due to
its large sized data.

Instead of executing the `start.cmd` straight away, please script it inside and
place it in a project directory. A simple example would be:

```
#!/bin/sh
/path/to/Upscaler/start.cmd --model ultrasharp \
	--scale 4 \
	--input ./sample-vid.mp4 \
	--video
```

This is for resuming the upscaling project in case of crashes or long hours
work. A good directory looks something as follows:

```
/path/to/my-upscaled-project/
├── run.sh
└── sample-vid.mp4
```

#### Run The Initator Script
To initiate or to resume project, simply run your initiated project:

```
# cd /path/to/my-upscaled-project
$ ./run.sh
```

The Upscaler will create a workspace to house its output frames and control
values.

#### Resetting the Project
Just in case if you bump into something odd that requires to restart the project
from start, you can delete the `-workspace` directory inside the project to
restart all over again.




## Helping The Project
Stars, Watch, or the best: sponsor the contributors.
