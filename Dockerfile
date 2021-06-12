FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

#у меня в деревне такой инет, что сразу все зависимости не выкачиваются, и этот уровень завершается.
#попробую ставить зависимости по частям, чтоб меньше качать

RUN apt-get update && apt-get install --no-install-recommends -y git 

RUN apt-get install --yes wget tree

# isntall mapillary_tools

RUN apt-get install --yes python3-pip


RUN apt-get install --yes exiftool dialog whiptail

#for sjcam
RUN apt-get install --yes imagemagick parallel 

#reverse geocoding for youtube timelapse
RUN apt-get install --no-install-recommends -y jq curl gpsbabel ffmpeg



ADD https://api.github.com/repos/mapillary/mapillary_tools/git/refs/heads/master   mapillary_tools-ver.json
RUN pip install --upgrade git+https://github.com/mapillary/mapillary_tools

ADD https://api.github.com/repos/trolleway/mapillary.sh/git/refs/heads/master   mapillary.sh-ver.json
#The API call will return different results when the head changes, invalidating the docker cache

RUN git clone --recurse-submodules https://github.com/trolleway/mapillary.sh.git

RUN chmod  --recursive 777 /mapillary.sh


WORKDIR /mapillary.sh


CMD ["/bin/bash"]
