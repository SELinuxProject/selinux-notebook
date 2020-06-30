#!/bin/sh

echo 1 > /proc/sys/net/ipv4/conf/lo/disable_xfrm
echo 1 > /proc/sys/net/ipv4/conf/lo/disable_policy
ip xfrm policy flush
ip xfrm state flush
