# mapillary.sh
mapillary upload scripts for my cameras using parallel in bash

# Usage

```
docker build --tag tm:1.0 .
docker run -i -t -v c:\trolleway\mapillary\:/data -v c:\trolleway\mapillary.sh\:/code tm:1.0 /bin/bash

mapillary_tools --advanced  authenticate
```
