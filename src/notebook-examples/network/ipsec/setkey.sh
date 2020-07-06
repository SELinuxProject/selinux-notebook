#!/bin/sh

echo 0 > /proc/sys/net/ipv4/conf/lo/disable_xfrm
echo 0 > /proc/sys/net/ipv4/conf/lo/disable_policy

setkey -f ./ipsec/setkey
setkey -DP
