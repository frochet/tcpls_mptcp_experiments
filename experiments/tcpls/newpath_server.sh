#!/bin/bash
sleep 5
ifconfig Server_0-eth0 up
ip route add default via 10.1.0.2 dev Server_0-eth0
