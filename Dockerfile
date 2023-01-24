#
# BilibiliDownloader Dockerfile
#
# https://github.com/ljq29/BilibiliDownloader
#


FROM python:alpine3.17
ARG YOUTUBE_DL=youtube_dl
ARG ATOMICPARSLEY=0

VOLUME "/BilibiliDownloads"
VOLUME "/app_config"

# 下载lux
RUN apt install python3 python3-pip ffmpeg -y
RUN wget https://github.com/iawia002/lux/releases/download/v0.15.0/lux_0.15.0_Linux_64-bit.tar.gz && tar -zxvf lux*.tar.gz && chmod 0777 lux && cp lux /usr/local/bin/ && rm -rf lux*
RUN lux -v

RUN wget 
RUN pip install --no-cache /wheels/*

RUN mkdir -p /usr/src/app
RUN apk add --no-cache ffmpeg tzdata mailcap
RUN if [ $ATOMICPARSLEY == 1 ]; then apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing atomicparsley; ln /usr/bin/atomicparsley /usr/bin/AtomicParsley || true; fi
COPY ./requirements.txt /usr/src/app/
RUN pip install --upgrade pip && sed -i s/youtube-dl/${YOUTUBE_DL}/ /usr/src/app/requirements.txt && pip install --no-cache-dir -r /usr/src/app/requirements.txt

COPY ./bootstrap.sh /usr/src/app/
COPY ./docker_run.sh /usr/src/app/
COPY ./config.yml /usr/src/app/default_config.yml
COPY ./ydl_server /usr/src/app/ydl_server
COPY ./youtube-dl-server.py /usr/src/app/

WORKDIR /usr/src/app

RUN apk add --no-cache wget && ./bootstrap.sh && apk del wget


EXPOSE 8080

ENV YOUTUBE_DL=$YOUTUBE_DL
ENV YDL_CONFIG_PATH='/app_config'
CMD [ "./docker_run.sh" ]
