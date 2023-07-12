#!/bin/bash

for pidfile in  pid/*.pid; do
	kill $(cat $pidfile) && rm -f $pidfile
done

for iface in can0 can1 ; do
	ip link del $iface
done

cangw -F
