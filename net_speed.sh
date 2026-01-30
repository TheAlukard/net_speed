#!/bin/sh

set -e

count=256
# minimum is 8, because we have to subtract the 8 bytes that make up the header and 'ping' doesn't take a size less than 0
psize=8
# minimum is 2ms
inter=10
addr=google.com

PACKET_SIZE=$(($psize - 8))
INTERVAL=$(echo "$inter / 1000" | bc -l)

expr_transmitted='([0-9]*[0-9])(?=.packets transmitted)'
expr_received='([0-9]*[0-9])(?=.received)'
expr_time='(?<=time.)([0-9]*[0-9])(?=ms)'
expr_ploss='([0-9]*[0-9].?[0-9]*[0-9]|[0-9]*[0-9])(?=%)'

out=$(ping -3 -f -i $INTERVAL -s $PACKET_SIZE -c $count $addr)

transmitted=$(echo $out | grep -Po "$expr_transmitted")
received=$(echo $out | grep -Po "$expr_received")
time=$(echo $out | grep -Po "$expr_time")
ploss=$(echo $out | grep -Po "$expr_ploss")
bits=$(($received * $psize * 8))
speed=$(echo "$bits / ($time - ($inter * ($count - 1)))" | bc -l) # bits/ms
KBps=$(echo "($speed * 1000) / 8 / 1024" | bc -l)

echo $out
echo "Trasmitted: $transmitted"
echo "Received: $received"
echo "Time: $time"
echo "Packet Loss: $ploss"
echo "Bits: $bits"
echo "Speed: $speed"
echo "KBps: $KBps"
