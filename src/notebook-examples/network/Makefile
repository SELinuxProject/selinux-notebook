TARGETS = nb_client nb_server
CFLAGS ?= -Wall
LDLIBS += -lselinux

cipso:	$(TARGETS)
	./netlabel/cipso.sh

calipso:	$(TARGETS)
	./netlabel/calipso.sh

ip-xfrm:	$(TARGETS)
	./ipsec/ip-xfrm.sh

setkey:	$(TARGETS)
	./ipsec/setkey.sh

clean:
	./netlabel/cipso-flush.sh
	./netlabel/calipso-flush.sh
	./ipsec/ipsec-flush.sh
	echo 1 > /proc/sys/net/ipv4/conf/lo/disable_xfrm
	echo 1 > /proc/sys/net/ipv4/conf/lo/disable_policy

clean-all: clean
	rm -f $(TARGETS)
