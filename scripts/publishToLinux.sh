#!/usr/local/bin/bash

ssh -t kirill@spbdotnet.local 'mkdir -p /spbdotnet/docker/netcore3.1/'
#scp ../Dockerfile kirill@spbdotnet.local:/spbdotnet/docker/netcore3.1/
rsync -ar --progress ../Dockerfile* kirill@spbdotnet.local:/spbdotnet/docker/netcore3.1/

