#!/usr/local/bin/bash

find ../ -name ".DS_Store" -delete
dotnet publish --runtime linux-x64 -c Release --self-contained true -o ../spbdotnet3installer/usr/bin/spbdotnet3.service/ ../SpbDotNetCore3
dpkg-deb --build ../spbdotnet3installer/
scp ../spbdotnet3installer.deb kirill@spbdotnet.local:/spbdotnet
#ssh -t kirill@spbdotnet.local 'sudo dpkg -i /spbdotnet/spbdotnet3installer.deb' 