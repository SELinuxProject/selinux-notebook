#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netdb.h>
#include <stdbool.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <selinux/selinux.h>

static char *get_ip_option(int fd, bool ipv4, socklen_t *opt_len)
{
	int ret, i;
	uint32_t doi;
	unsigned char ip_options[1024], *opt_ptr;
	socklen_t len = sizeof(ip_options);
	char *ip_optbuf;

	if (ipv4)
		ret = getsockopt(fd, IPPROTO_IP, IP_OPTIONS,
				    ip_options, &len);
	else
		ret = getsockopt(fd, IPPROTO_IPV6, IPV6_HOPOPTS,
				    ip_options, &len);
	if (ret < 0) {
		perror("get ip options error");
		return NULL;
	}

	ip_optbuf = calloc(1, len * 2 + 1);
	if (!ip_optbuf) {
		perror("get ip options malloc error");
		return NULL;
	}

	if (len > 0) {
		if (ipv4) {
			opt_ptr = &ip_options[2];
			memcpy(&doi, opt_ptr, sizeof(uint32_t));
			printf("CIPSO DOI: %d Tag: %d\n", ntohl(doi),
			       ip_options[6]);
		} else {
			opt_ptr = &ip_options[4];
			memcpy(&doi, opt_ptr, sizeof(uint32_t));
			printf("CALIPSO DOI: %d\n", ntohl(doi));
		}

		for (i = 0; i < len; i++)
			sprintf(&ip_optbuf[i * 2], "%02x", ip_options[i]);

		*opt_len = len;
		return ip_optbuf;
	}

	return NULL;
}

static void print_ip_option(int fd, bool ipv4, char *text)
{
	char *ip_options;
	socklen_t len;

	ip_options = get_ip_option(fd, ipv4, &len);

	if (ip_options) {
		printf("%s IP Options - Family: %s Length: %d\n\tIP Option data: %s\n",
		       text, ipv4 ? "IPv4" : "IPv6", len, ip_options);
		free(ip_options);
	} else {
		printf("%s No IP Options set\n", text);
	}
}

#define MAXBUFFERSIZE 256
#define RED	"\x1b[31m"
#define GREEN	"\x1b[32m"
#define RESET	"\x1b[0m"

int main(int argc, char *argv[])
{
	int sock, bytes_received, ret;
	char buffer[MAXBUFFERSIZE];
	char *context, *peer_context, *peer_context_str;
	bool ipv4 = false;
	struct addrinfo hints, *serverinfo;
	struct timeval tm;

	if (argc != 3) {
		fprintf(stderr, "usage: %s <address> <port>\n", argv[0]);
		exit(1);
	}

	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;

	ret = getaddrinfo(argv[1], argv[2], &hints, &serverinfo);
	if (ret < 0) {
		fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(ret));
		exit(1);
	}

	if (serverinfo->ai_family == AF_INET)
		ipv4 = true;

	sock = socket(serverinfo->ai_family, serverinfo->ai_socktype,
			 serverinfo->ai_protocol);
	if (sock < 0) {
		perror("Client Socket");
		exit(1);
	}

	tm.tv_sec = 5;
	tm.tv_usec = 0;
	if (setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &tm, sizeof(tm)) < 0) {
		perror("setsockopt: SO_SNDTIMEO");
		exit(1);
	}

	if (getpeercon(sock, &peer_context) < 0) {
		printf("open socket - No Peer Context Available\n");
	} else {
		printf("open socket - Peer Context: %s\n", peer_context);
		free(peer_context);
	}

	if (connect(sock, serverinfo->ai_addr, serverinfo->ai_addrlen) < 0) {
		perror("connect");
		close(sock);
		exit(1);
	}

	if (getpeercon(sock, &peer_context) < 0) {
		printf("connect - No Peer Context Available\n");
	} else {
		printf("connect - Peer Context: %s\n", peer_context);
		free(peer_context);
	}

	memset(buffer, 0, sizeof(buffer));
	bytes_received = recv(sock, buffer, MAXBUFFERSIZE-1, 0);
	if (bytes_received < 0) {
		perror("Client recv");
		exit(1);
	}

	print_ip_option(sock, ipv4, "Client Receive Buffer");

	if (getpeercon(sock, &peer_context) < 0) {
		printf("recv - No Peer Context Available\n");
	} else {
		printf("recv - Peer Context: %s\n", peer_context);
		free(peer_context);
	}

	buffer[bytes_received] = '\0'; /* Add null at end of line. */
	printf("\n%sInformation from Server in RED:\n%s%s\n",
		RED, buffer, RESET);

	/* Print the Clients context information */
	if (getcon(&context) < 0) {
		perror("Client context");
		exit(1);
	}

	if (getpeercon(sock, &peer_context) < 0) {
		peer_context_str = strdup("No Peer Context Available");
	} else {
		peer_context_str = strdup(peer_context);
		free(peer_context);
	}
	printf("%sClient Information in GREEN:\n", GREEN);
	printf("Client Context: %s\nClient Peer Context: %s%s\n",
		context, peer_context_str, RESET);

	free(context);
	close(sock);
	exit(0);
}
