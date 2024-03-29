#!/bin/bash
#-------------VARS--------------------------------------------------
SPEED=$1                 # Throughput, задаётся в формате "10g"
TIME=10                  # Время теста
WORKERS=$2               # Кол-во параллельных процессов iperf3
SERVER=10.0.0.10         # IP сервера iperf3
INT=10.0.0.7             # IP интерфейса тестирования клиента iperf3
PROTO="UDP"		           # Протокол для тестирования, "TCP" или "UDP"
PACKET=1460              # Размер буфера/пакета (применяется только для UDP, для TCP используется значение по-умолчанию 128К)
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
  SUM_LOST=0
  SUM_TOTAL=0
  for ((p=1; p<=$WORKERS; p++))
  do
    FILE=$PROTO-$SPEED-$p.log
    BITRATE=$(cat $FILE | grep " receiver" | awk -F " " '{ print $7 }')
    LOST=$(cat $FILE | grep " receiver" | awk -F " " '{ print $11 }' | awk -F"/" '{ print $1 }')
    TOTAL=$(cat $FILE | grep " receiver" | awk -F " " '{ print $11 }' | awk -F"/" '{ print $2 }')
    echo "Process "$p" throughput: "$BITRATE" Gbits/s, lost: "$LOST", total: "$TOTAL
    SUM_BITRATE=$(echo "$SUM_BITRATE + $BITRATE" | bc)
    SUM_LOST=$(echo "$SUM_LOST + $LOST" | bc)
    SUM_TOTAL=$(echo "$SUM_TOTAL + $TOTAL" | bc)
    rm -f $FILE
  done

  PERCENT=$(echo "scale=4; $SUM_LOST / $SUM_TOTAL * 100" | bc)
  echo "---------------------------------------------------"
  echo "Sum throughput: "$SUM_BITRATE" Gbits/s"
  echo "Sum lost datagrams: "$SUM_LOST
  echo "Sum total datagrams: "$SUM_TOTAL
  echo "% Lost datagrams: "$PERCENT
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
