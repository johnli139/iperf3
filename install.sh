#!/bin/bash

cd $HOME

# install packets and dependencies:
yum install -y gcc gcc-c++ make automake git wget unzip

# install iperf3
wget --no-check-certificate https://codeload.github.com/esnet/iperf/zip/master -O iperf3.zip
unzip iperf3.zip
cd iperf-master
./configure
make
make install

iperf3 --version | head -n1
