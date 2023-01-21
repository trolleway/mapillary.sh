FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN apt-get update && apt-get install --no-install-recommends -y git wget tree python3-pip exiftool dialog whiptail imagemagick parallel  jq curl gpsbabel ffmpeg


#reverse geocoding for youtube timelapse: jq curl gpsbabel ffmpeg

ADD https://api.github.com/repos/mapillary/mapillary_tools/git/refs/heads/master   mapillary_tools-ver.json
RUN pip install --upgrade git+https://github.com/mapillary/mapillary_tools

ADD https://api.github.com/repos/trolleway/mapillary.sh/git/refs/heads/master   mapillary.sh-ver.json
#The API call will return different results when the head changes, invalidating the docker cache

RUN git clone --recurse-submodules https://github.com/trolleway/mapillary.sh.git

RUN chmod  --recursive 777 /mapillary.sh


WORKDIR /mapillary.sh


CMD ["/bin/bash"]
