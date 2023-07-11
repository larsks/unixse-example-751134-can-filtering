#!/bin/bash

: "${CAN_TESTUSER:=${1:-$SUDO_USER}}"
: "${CAN_TESTGID:=${2:-$SUDO_GID}}"

set -e

mkdir -p pid
echo "creating virtual cable"
socat pty,rawer,link=/tmp/can0 pty,rawer,link=/tmp/can1 > /dev/null &
echo $! > pid/socat.pid

while ! [[ -c $(readlink /tmp/can0) ]]; do
	sleep 0.1
done

for iface in can0 can1; do
	echo "creating interface $iface"
	slcand -S 115200 "$(readlink /tmp/$iface)" -F "$iface" > /dev/null &
	echo $! > pid/$iface.pid
	ip link set $iface up
done

sed "s/CAN_TESTGID/${CAN_TESTGID}/g" egress.nft | nft -f-

candump can1 &
echo $! > pid/candump.pid

echo "Running cangen as root"
cangen -n4 can0

# as another user
echo "Running cangen as ${CAN_TESTUSER} (gid ${CAN_TESTGID})"
su -c 'cangen -n4 can0' ${CAN_TESTUSER}
