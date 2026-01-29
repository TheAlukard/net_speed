#!/bin/sh


count=256
# minimum is 8, because we have to subtract the 8 bytes that make up the header and 'ping' doesn't take a size less than 0
p_size=8
# minimum is 2ms
inter=10
addr=google.com

PACKET_SIZE=$(($p_size - 8))
INTERVAL=$(echo "$inter / 1000" | bc -l)

transmitted='(\\d+)(?=.packets transmitted)'

out=$(ping -3 -f -i $INTERVAL -s $PACKET_SIZE -c $count $addr)

echo $out
