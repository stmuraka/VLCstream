FROM ubuntu:xenial
MAINTAINER Shaun Murakami <stmuraka@us.ibm.com>

EXPOSE 8080

RUN apt-get -y update \
 && apt-get -y install \
        vlc \
# Cleanup package files
 && apt-get autoremove  \
 && apt-get autoclean

# Create VLC user
RUN useradd -m vlc

WORKDIR /home/vlc

ARG VIDEO_SOURCE
ENV VIDEO_SOURCE=${VIDEO_SOURCE:-"http://www.sample-videos.com/video/mkv/720/big_buck_bunny_720p_50mb.mkv"}
# other videos: http://www.divx.com/en/devices/profiles/video

ADD ${VIDEO_SOURCE} /home/vlc/
RUN chown -R vlc:vlc /home/vlc/

USER vlc

# Stream video over http on port 8080
#CMD cvlc -vvv ./big_buck_bunny_720p_50mb.mkv --sout-keep --loop --sout='#transcode{vcodec=mp4v,vb=1024}:standard{mux=ts,dst=0.0.0.0,access=http}'
#ENTRYPOINT ["cvlc", "-v", "./$(basename ${VIDEO_SOURCE})", "--sout-keep", "--loop"]
#CMD ["--sout='#transcode{vcodec=h264,vb=1024}:standard{mux=ts,dst=0.0.0.0,access=http}'"]
CMD cvlc -v ./$(basename ${VIDEO_SOURCE}) --sout-keep --loop --file-logging --sout='#transcode{vcodec=m4v,vb=1024}:standard{mux=ts,dst=0.0.0.0,access=http}'
