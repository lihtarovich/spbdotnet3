#!/usr/local/bin/bash

find ../ -name ".DS_Store" -delete
rm -rf ../spbdotnet3installer/usr/
dotnet publish --runtime linux-x64 -c Release -p:PublishTrimmed=True --self-contained true -o ../spbdotnet3installer/usr/bin/spbdotnet3.service/ ../SpbDotNetCore3
find ../ -name ".DS_Store" -delete
dpkg-deb --build ../spbdotnet3installer/
mv ../spbdotnet3installer.deb ../spbdotnet3_at_sc.deb
scp ../spbdotnet3_at_sc.deb kirill@spbdotnet.local:/spbdotnet
#ssh -t kirill@spbdotnet.local 'sudo dpkg -i /spbdotnet/spbdotnet3installer.deb' 