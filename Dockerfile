#FROM ubuntu:20.04
FROM python:3.9-slim-buster
#mapillary tools work under python2.7, so in ubuntu higher 18 is hard to install old python 

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

#у меня в деревне такой инет, что сразу все зависимости не выкачиваются, и этот уровень завершается.
#попробую ставить зависимости по частям, чтоб меньше качать

RUN apt update && apt install --no-install-recommends -y git wget tree exiftool dialog whiptail


# isntall mapillary_tools

RUN apt-get install --yes python3 python3-pip
RUN python3 -m pip install --upgrade git+https://github.com/mapillary/mapillary_tools


#for sjcam
RUN apt-get install --yes imagemagick parallel 

#reverse geocoding for youtube timelapse
#google street view uploader on bash
RUN apt-get install --no-install-recommends -y jq curl

#video
RUN apt-get install --no-install-recommends -y ffmpeg
RUN apt-get install --no-install-recommends -y gpsbabel

ADD https://api.github.com/repos/trolleway/mapillary.sh/git/refs/heads/master   ver.json
#The API call will return different results when the head changes, invalidating the docker cache
RUN git clone --recurse-submodules https://github.com/trolleway/mapillary.sh.git
RUN chmod  --recursive 777 /mapillary.sh
WORKDIR /mapillary.sh

CMD ["/bin/bash"]
#ENTRYPOINT ./interface.sh
