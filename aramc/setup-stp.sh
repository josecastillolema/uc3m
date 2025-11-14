#!/bin/sh
set -eux

# Create a Linux bridge and attach interfaces
ip link add name br0 type bridge
ip link set br0 type bridge stp_state 1   # Enable STP

# Attach all ethernet interfaces except lo
for iface in $(ls /sys/class/net | grep ^eth); do
  ip link set "$iface" master br0
done

# Bring up interfaces and bridge
for iface in $(ls /sys/class/net | grep ^eth); do
  ip link set "$iface" up
done

ip link set br0 up

# Display initial state
bridge link
