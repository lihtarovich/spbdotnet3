#!/bin/bash

docker build --no-cache -f /spbdotnet/published/netcore3.1/Dockerfile -t spbdotnet3:0.0.1 --build-arg dbhost=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') /spbdotnet/published/netcore3.1/
docker run -d --name spbdotnet3 -p 5003:5003 -e ASPNETCORE_URLS="https://+" -e ASPNETCORE_HTTPS_PORT=5003 -e ASPNETCORE_Kestrel__Certificates__Default__Password="123QWEasd" -e ASPNETCORE_Kestrel__Certificates__Default__Path=/usr/bin/spbdotnet3/spbdotnet.pfx  spbdotnet3:0.0.1 