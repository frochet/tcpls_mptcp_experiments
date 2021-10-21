#!/bin/bash
sleep 5
ifconfig Client_0-eth0 up
ip route add default via 10.0.0.2 dev Client_0-eth0
