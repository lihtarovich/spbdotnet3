#!/usr/local/bin/bash

ssh -t kirill@spbdotnet.local 'mkdir -p /spbdotnet/docker/netcore3.1/'
scp ../Dockerfile kirill@spbdotnet.local:/spbdotnet/docker/netcore3.1/
#rsync -ar --progress ../spbdotnet3installer/spbdotnet3 kirill@spbdotnet.local:/spbdotnet/published/netcore3.1/

