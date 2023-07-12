#!/bin/bash

: "${CAN_TESTUSER:=${1:-$SUDO_USER}}"
: "${CAN_TESTGID:=${2:-$SUDO_GID}}"

set -e

mkdir -p pid

for iface in can0 can1; do
	echo "creating interface $iface"
	ip link add $iface type vcan
	ip link set $iface up
done

echo "configuring can gw"
cangw -A -s can0 -d can1 -e

sed "s/CAN_TESTGID/${CAN_TESTGID}/g" egress.nft | nft -f-

candump can1 &
echo $! > pid/candump.pid

echo "Running cangen as root"
cangen -n4 can0

# as another user
echo "Running cangen as ${CAN_TESTUSER} (gid ${CAN_TESTGID})"
su -c 'cangen -n4 can0' ${CAN_TESTUSER}
