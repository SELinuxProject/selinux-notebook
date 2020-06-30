# CIPSO, CALIPSO and IPSEC Demo

This section will allow simple demos to show networking information from:

1) CIPSO using ***netlabelctl**(8)* - Shows peerlabel + CIPSO netlabel config, DOI and Tag type
-   Use `make cipso`
2) CALIPSO using ***netlabelctl**(8)* - Shows peerlabel + CIPSO netlabel config and DOI
-   Use `make calipso`
3) IPSEC using ***ip-xfrm**(8)* - Shows peerlabel + ip config
-   Use `make ip-xfrm`
4) IPSEC using ***setkey**(8)* - Shows peerlabel + ip config
-   Use `make setkey`

The Makefile will build the client/server by default.

1) Make the applicable target.
2) In one terminal session run the server:
`./nb_server 9999`

3) In another terminal session (for CIPSO and IPSEC build) run:
`./nb_client 127.0.0.1 9999`

-  for CALIPSO (as IPV6) run:
`./nb_client ::1 9999`

For the CIPSO demo (using Tag type 5) the client will display:

```
./nb_client 127.0.0.1 9999
open socket - Peer Context: system_u:object_r:unlabeled_t:s0
connect - Peer Context: system_u:object_r:netlabel_peer_t:s0
CIPSO DOI: 87654321 Tag: 5
Client Receive Buffer IP Options - Family: IPv4 Length: 12
	IP Option data: 860a05397fb1050400000000
recv - Peer Context: system_u:object_r:netlabel_peer_t:s0

Information from Server in RED:
This is Message-1 from the server listening on port: 9999
Client source port: 35378
Server Context: unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
Server Peer Context: system_u:object_r:netlabel_peer_t:s0

Client Information in GREEN:
Client Context: unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
Client Peer Context: system_u:object_r:netlabel_peer_t:s0
```

4) Once finished, run `make clean` to remove the configurations.
