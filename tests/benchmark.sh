#!/bin/bash
if [ -f "./start.cmd" ]; then
        rm -rf ./tests/video/sample-1-640x360-upscaled_workspace &> /dev/null
        rm -rf ./tests/video/sample-1-640x360-upscaled.mp4 &> /dev/null
        time ./start.cmd \
                --model upscayl-ultrasharp2 \
                --scale 4 \
                --format webp \
                --video \
                --input tests/video/sample-1-640x360.mp4
else
        printf "[ ERROR ] Please make sure you're at the root location of the repo!\n"
fi
