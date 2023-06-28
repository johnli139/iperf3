#!/bin/bash
#-------------VARS--------------------------------------------------
WORKERS=$1              # Кол-во параллельных процессов
INT=10.0.0.10           # IP интерфейса тестирования
#-------------------------------------------------------------------
for ((p=1; p<=$WORKERS; p++))
do
  PORT=$((13000+$p))                                         # Для каждого процесса свой порт
  FILE=$p.log
#  CORE=$((2*$p))                                            # Для каждого процесса своё выделенное ядро: -a $CORE
  iperf3 -s -B $INT -p $PORT -i 0 -f g --logfile $FILE &                    # iperf3 server, универсальный для TCP и UDP
done

echo Server is running $WORKERS processes
echo Press any key to stop server processes
read -n 1 key

for ((p=1; p<=$WORKERS; p++))
do
  FILE=$p.log
  rm -f $FILE
  kill %$p
done
