#!/bin/sh

set -e

count=256
# minimum is 8, because we have to subtract the 8 bytes that make up the header and 'ping' doesn't take a size less than 0
psize=64
# minimum is 2ms
inter=2
addr=google.com

PACKET_SIZE=$(($psize - 8))
INTERVAL=$(echo "$inter / 1000" | bc -l)

expr_transmitted='([0-9]*[0-9])(?=.packets transmitted)'
expr_received='([0-9]*[0-9])(?=.received)'
expr_time='(?<=time.)([0-9]*[0-9])(?=ms)'
expr_ploss='([0-9]*[0-9].?[0-9]*[0-9]|[0-9]*[0-9])(?=%)'

out=$(ping -3 -i $INTERVAL -s $PACKET_SIZE -c $count $addr)

transmitted=$(echo $out | grep -Po "$expr_transmitted")
received=$(echo $out | grep -Po "$expr_received")
time=$(echo $out | grep -Po "$expr_time")
ploss=$(echo $out | grep -Po "$expr_ploss")
bits=$(($received * $psize * 8))
realtime=$(echo "($time - ($inter * ($count - 1))) / $count" | bc -l)
speed=$(echo "$bits / $realtime" | bc -l) # bits/ms
Kbps=$(echo "($speed * 1000) / 1024" | bc -l)
KBps=$(echo "($speed * 1000) / 8 / 1024" | bc -l)
Mbps=$(echo "$Kbps / 1024" | bc -l)
MBps=$(echo "$KBps / 1024" | bc -l)

echo "Trasmitted: $transmitted"
echo "Received: $received"
echo "Time: $time"
echo "Real Time": $realtime
echo "Packet Loss: $ploss"
echo "Bits: $bits"
echo "Speed (bits/second): $speed"
echo "Mbps: $Mbps"
echo "MBps: $MBps"
