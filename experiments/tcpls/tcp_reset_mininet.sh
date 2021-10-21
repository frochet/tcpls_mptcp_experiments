#!/bin/bash
TIME=$1
IP_SRC_1=10.0.0.1
IP_SRC_2=10.0.1.1
IP_DEST_1=10.1.0.1
IP_DEST_2=10.1.1.1
IPPATH=0

sleep 5
printf "Starting to backhole traffic\n"
while true;
do
  if [ $IPPATH -eq 0 ]
  then
    printf "Sending a rst on Path 0\n"
    date +"%T.%6N"
    iptables -A FORWARD -p tcp -s $IP_SRC_1 -j REJECT --reject-with tcp-reset
    iptables -A FORWARD -p tcp -s $IP_DEST_1 -j  REJECT --reject-with tcp-reset
    iptables -A FORWARD -p tcp -d $IP_DEST_1 -j REJECT --reject-with tcp-reset
    iptables -A FORWARD -p tcp -d $IP_SRC_1 -j REJECT --reject-with tcp-reset
    IPPATH=1
  else
    printf "Sending a rst on Path 1\n"
    #iptables -A FORWARD -p tcp -s $IP_SRC_1 -d $IP_DEST_2 -j DROP
    date +"%T.%6N"
    iptables -A FORWARD -p tcp -s $IP_SRC_2  -j REJECT --reject-with tcp-reset
    iptables -A FORWARD -p tcp -s $IP_DEST_2  -j REJECT --reject-with tcp-reset
    iptables -A FORWARD -p tcp -d $IP_DEST_2 -j REJECT --reject-with tcp-reset
    iptables -A FORWARD -p tcp -d $IP_SRC_2 -j REJECT --reject-with tcp-reset
    IPPATH=0
  fi
  sleep $TIME
  iptables -F
done

