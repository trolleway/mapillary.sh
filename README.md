# mapillary.sh
mapillary upload scripts for my cameras using parallel in bash

# Usage

```
docker build --tag tm:1.0 .


docker run -d -rm -p 4444:4444 --name selenium  selenium/standalone-chrome

docker run -i --rm --link selenium:selenium -t -v ${PWD}:/data tm:1.0 /bin/bash

mapillary_tools authenticate
```
