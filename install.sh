#!/bin/bash

# install packets and dependencies:
yum install -y gcc gcc-c++ make automake git wget unzip

# clone repository:
cd $HOME
git clone https://github.com/johnli139/iperf3.git

# install iperf3
wget --no-check-certificate https://codeload.github.com/esnet/iperf/zip/master -O iperf3.zip
unzip iperf3.zip
cd iperf-master
./configure
make
make install

cd $HOME/iperf3
