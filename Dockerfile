FROM ubuntu:18.04
#mapillary tools work under python2.7, so in ubuntu higher 18 is hard to install old python 

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

#у меня в деревне такой инет, что сразу все зависимости не выкачиваются, и этот уровень завершается.
#попробую ставить зависимости по частям, чтоб меньше качать

RUN apt-get update && apt-get install --no-install-recommends -y git 

RUN apt-get install --yes wget tree

# isntall mapillary_tools

RUN apt-get install --yes python-pip
RUN pip install git+https://github.com/mapillary/Piexif
RUN pip install --upgrade git+https://github.com/mapillary/mapillary_tools
RUN apt-get install --yes exiftool 

#for sjcam
RUN apt-get install --yes imagemagick parallel 

#reverse geocoding for youtube timelapse
RUN apt-get install --no-install-recommends -y jq curl

#video
RUN apt-get install --no-install-recommends -y ffmpeg

CMD ["/bin/bash"]
