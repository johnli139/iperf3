#!/bin/bash
#-------------VARS--------------------------------------------------
SPEED=$1                 # Throughput, задаётся в формате "10g"
TIME=5                   # Время теста
WORKERS=$2               # Кол-во параллельных процессов
SERVER=10.0.0.10         # IP сервера
INT=10.0.0.7             # IP интерфейса тестирования
PROTO="UDP"		 # Протокол для тестирования, TCP или UDP
PACKET=1460              # Размер пакета
#--------------------------------------------------------------------
if [ "$PROTO" =  "UDP" ]
then

#  nstat -n
#  ssh root@$SERVER -i .ssh/sbercloud.pem "nstat -n"
  for ((p=1; p<=$WORKERS; p++))
  do
    PORT=$((13000+$p))
    FILE=$PROTO-$SPEED-$p.log
#    CORE=$((2*$p))
    iperf3 -c $SERVER -B $INT -p $PORT -u -b $SPEED -4 -t $TIME -l $PACKET -i 0 -f g --logfile $FILE &
#    iperf  -c 192.168.10.151 -B 192.168.10.49 -p $PORT -u -b $SPEED -e -t $TIME -l 8192 &
  done

#  sleep $TIME
#  nstat -s > /root/nstat-client-$SPEED-$WORKERS.out
#  ssh root@$SERVER -i .ssh/sbercloud.pem "nstat -s" > /root/nstat-server-$SPEED-$WORKERS.out
#  echo client: && cat nstat-client-$SPEED-$WORKERS.out | grep -i UDPout && echo server: && cat nstat-server-$SPEED-$WORKERS.out | grep -i UDP

  echo "---------------------------------------------------"
  echo Started $WORKERS $PROTO-processes test for $TIME seconds...
  sleep "$((TIME+1))"

  SUM_BITRATE=0
  SUM_LOSS=0
  for ((p=1; p<=$WORKERS; p++))
  do
    FILE=$PROTO-$SPEED-$p.log
    BITRATE=$(cat $FILE | grep " receiver" | awk -F " " '{ print $7 }')
    LOSS=$(cat $FILE | grep " receiver" | awk -F " " '{ print $12 }')
    echo "Process "$p" throughput: "$BITRATE" Gbits/s, datagram loss: "$LOSS
    SUM_BITRATE=$(echo "$SUM_BITRATE + $BITRATE" | bc)
#    SUM_LOSS=$(echo "$SUM_LOSS + $LOSS" | bc)
    rm -f $FILE
  done

  echo "---------------------------------------------------"
  echo "Sum throughput: "$SUM_BITRATE" Gbits/s"
#  echo "Sum datagram loss: "$SUM_LOSS
  echo "---------------------------------------------------"

elif [ "$PROTO" = "TCP" ]
then

  for ((p=1; p<=$WORKERS; p++))
  do
    PORT=$((13000+$p))
    FILE=$PROTO-$SPEED-$p.log
#    CORE=$((2*$p))
    iperf3 -c $SERVER -B $INT -p $PORT -b $SPEED -4 -t $TIME -i 0 -f g --logfile $FILE  &
  done

  echo "---------------------------------------------------"
  echo Started $WORKERS $PROTO-processes test for $TIME seconds...
  sleep "$((TIME+1))"

  SUM_BITRATE=0
  SUM_RTRY=0
  for ((p=1; p<=$WORKERS; p++))
  do
    FILE=$PROTO-$SPEED-$p.log
    BITRATE=$(cat $FILE | grep sender | awk -F " " '{ print $7 }')
    RTRY=$(cat $FILE | grep sender | awk -F " " '{ print $9 }')
    echo "Process "$p" throughput: "$BITRATE" Gbits/s, rtry: "$RTRY
    SUM_BITRATE=$(echo "$SUM_BITRATE + $BITRATE" | bc)
    SUM_RTRY=$(echo "$SUM_RTRY + $RTRY" | bc)
    rm -f $FILE
  done

  echo "---------------------------------------------------"
  echo "Sum throughput: "$SUM_BITRATE" Gbits/s"
  echo "Sum retries: "$SUM_RTRY
  echo "---------------------------------------------------"

else
   echo "Error in PROTO variable"
fi
