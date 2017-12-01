#!/usr/bin/env bash

sandboxName="sandbox-hdf-bagel"
sandboxImage="sandbox-hdf-bagel:1.0"
hostname="sandbox-hdf.hortonworks.com"

docker run --privileged --name $sandboxName -h $hostname -itd \
-p 1080:1080 \
-p 2181:2181 \
-p 4200:4200 \
-p 4557:4557 \
-p 6080:6080 \
-p 6627:6627 \
-p 6667:6667 \
-p 7777:7777 \
-p 7788:7788 \
-p 8000:8000 \
-p 8080:8080 \
-p 8081:8081 \
-p 8088:8088 \
-p 8090:8090 \
-p 8744:8744 \
-p 9089:9089 \
-p 9090:9090 \
-p 19888:19888 \
-p 50070:50070 \
-p 15500:15500 \
-p 15501:15501 \
-p 15502:15502 \
-p 15503:15503 \
-p 15504:15504 \
-p 15505:15505 \
-p 2222:22 \
$sandboxImage
