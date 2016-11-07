#!/bin/bash

[ $# -ne 2 ] && { echo "ERROR: Usage: $0 tag video_source"; exit 1; }

docker build -t vlcstream/${1} --build-arg VIDEO_SOURCE="${2}" .
