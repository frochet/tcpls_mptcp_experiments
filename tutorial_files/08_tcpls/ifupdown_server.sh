#!/bin/bash
TIME=$1
IPPATH=0

sleep 5
while [ $IPPATH -le 1 ];
do
  if [ $IPPATH -eq 0 ]
  then
    printf "eth0 down, eth1 up\n"
    ifconfig Server_0-eth1 up
    #ip route add 10.0.1.0/24 via 10.1.1.2 dev Server_0-eth1
    ifconfig Server_0-eth0 down
    IPPATH=1
  else
    printf "eth1 down eth0 up\n"
    ifconfig Server_0-eth0 up
    ip route add default via 10.1.0.2 dev Server_0-eth0
    sleep 1
    ifconfig Server_0-eth1 down
    IPPATH=2
  fi
  sleep $TIME
done

