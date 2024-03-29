FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN apt-get update && apt-get install --no-install-recommends -y \
git wget tree python3-pip exiftool dialog whiptail imagemagick parallel jq curl gpsbabel ffmpeg gnupg2 


#reverse geocoding for youtube timelapse: jq curl gpsbabel ffmpeg

ADD https://api.github.com/repos/mapillary/mapillary_tools/git/refs/heads/main   mapillary_tools-ver.json
RUN pip install --upgrade git+https://github.com/mapillary/mapillary_tools

ADD https://api.github.com/repos/trolleway/mapillary.sh/git/refs/heads/master   mapillary.sh-ver.json
#The API call will return different results when the head changes, invalidating the docker cache

RUN git clone --recurse-submodules  https://github.com/trolleway/mapillary.sh.git

RUN chmod  --recursive 777 /mapillary.sh

RUN pip3 install selenium

# Adding trusting keys to apt for repositories

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Adding Google Chrome to the repositories
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Updating apt to see and install Google Chrome
RUN apt-get -y update

# Magic happens
RUN apt-get install -y google-chrome-stable

# Installing Unzip
RUN apt-get install -yqq unzip

# Download the Chrome Driver
# install chromedriver
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# Unzip the Chrome Driver into /usr/local/bin directory
#RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# Set display port as an environment variable
ENV DISPLAY=:99


WORKDIR /mapillary.sh


CMD ["/bin/bash"]
