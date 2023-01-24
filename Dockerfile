#
# BilibiliDownloader Dockerfile
#
# https://github.com/ljq29/BilibiliDownloader
#

FROM python:alpine3.17

VOLUME "/BilibiliDownloads"
VOLUME "/app_config"

RUN mkdir -p /usr/src/app
RUN apk add --no-cache wget 

# 下载lux
#RUN apt install python3 python3-pip ffmpeg -y
RUN wget https://github.com/iawia002/lux/releases/download/v0.15.0/lux_0.15.0_Linux_64-bit.tar.gz\
&& tar -zxvf lux*.tar.gz \
&& chmod 0777 lux \
&& cp lux /usr/local/bin/ \
&& rm -rf lux*
RUN lux -v

RUN wget https://github.com/ljq29/BilibiliDownloader/archive/refs/heads/main.zip
RUN tar -zxvf main*.zip \
&& cp main /usr/src/app/ \
&& rm -rf main*

RUN apk add --no-cache ffmpeg
COPY ./requirements.txt /usr/src/app/
RUN pip install --upgrade pip && pip install --no-cache-dir -r /usr/src/app/requirements.txt

WORKDIR /usr/src/app

RUN apk del wget

# EXPOSE 8080

ENV YOUTUBE_DL=$YOUTUBE_DL
ENV YDL_CONFIG_PATH='/app_config'
CMD [ "./docker_run.sh" ]
