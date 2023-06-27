#!/bin/bash
#-------------VARS--------------------------------------------------
SPEED=$1                 # Throughput, задаётся в формате "10g"
TIME=20                  # Время теста
WORKERS=$2               # Кол-во параллельных процессов
SERVER=192.168.10.151    # IP сервера
INT=192.168.10.49        # IP интерфейса тестирования
PACKET=128K              # Размер пакета
#--------------------------------------------------------------------
#nstat -n
#ssh root@192.168.10.151 -i .ssh/sbercloud.pem "nstat -n"
for ((p=1; p<=$WORKERS; p++))
do
PORT=$((13000+$p))
#CORE=$((2*$p))
iperf3 -c $SERVER -B $INT -p $PORT -b $SPEED -4 -V -t $TIME -l $PACKET -i 0 &
#iperf  -c 192.168.10.151 -B 192.168.10.49 -p $PORT -u -b $SPEED -e -t $TIME -l 8192 &
done
#sleep $TIME
#nstat -s > /root/nstat-client-$SPEED-$WORKERS.out
#ssh root@192.168.10.151 -i .ssh/sbercloud.pem "nstat -s" > /root/nstat-server-$SPEED-$WORKERS.out
#echo client: && cat nstat-client-$SPEED-$WORKERS.out | grep -i UDPout && echo server: && cat nstat-server-$SPEED-$WORKERS.out | grep -i UDP
