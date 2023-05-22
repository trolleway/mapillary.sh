docker build --tag tm:1.0 .
docker run -i -t --rm -v "${PWD}:/data" tm:1.0 /bin/bash
