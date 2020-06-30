#!/bin/sh

echo 0 > /proc/sys/net/ipv4/conf/lo/disable_xfrm
echo 0 > /proc/sys/net/ipv4/conf/lo/disable_policy
ip xfrm policy flush
ip xfrm state flush

ip xfrm state add src 127.0.0.1 dst 127.0.0.1 proto ah spi 0x200 ctx "unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023" auth sha1 0123456789012345
ip xfrm policy add src 127.0.0.1 dst 127.0.0.1 proto tcp dir out ctx "system_u:object_r:ipsec_spd_t:s0" tmpl proto ah mode transport level required

ip xfrm policy show
ip xfrm state show
