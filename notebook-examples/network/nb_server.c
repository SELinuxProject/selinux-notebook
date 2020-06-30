#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <selinux/selinux.h>

#define MAXBUFFERSIZE 256

int main(int argc, char *argv[])
{
	int sock, new_sock, message_id = 1, on = 1, ret;
	struct addrinfo hints, *res;
	struct sockaddr_in client_addr;
	socklen_t sin_size;
	char buffer[MAXBUFFERSIZE];
	char *context, *peer_context;
	char *peer_context_str = NULL;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s <port>\n", argv[0]);
		exit(1);
	}

	/* Add port info to send buffer and also display */
	sprintf(buffer, "Listening on port %s", argv[1]);
	printf("%s\n", buffer);

	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_flags = AI_PASSIVE;
	hints.ai_family = AF_INET6;

	ret = getaddrinfo(NULL, argv[1], &hints, &res);
	if (ret < 0) {
		printf("getaddrinfo: %s\n", gai_strerror(ret));
		exit(1);
	}

	sock = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
	if (sock < 0) {
		perror("socket");
		exit(1);
	}

	if (getpeercon(sock, &peer_context) < 0) {
		printf("open socket - No Peer Context Available\n");
	} else {
		printf("open socket - Peer Context: %s\n", peer_context);
		free(peer_context);
	}

	if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) < 0) {
		perror("Server setsockopt: SO_REUSEADDR");
		close(sock);
		exit(1);
	}

	if (bind(sock, res->ai_addr, res->ai_addrlen) < 0) {
		perror("Server bind");
		exit(1);
	}

	if (getpeercon(sock, &peer_context) < 0) {
		printf("bind - No Peer Context Available\n");
	} else {
		printf("bind - Peer Context: %s\n", peer_context);
		free(peer_context);
	}

	if (listen(sock, 5) < 0) {
		perror("Server listen");
		exit(1);
	}

	if (getpeercon(sock, &peer_context) < 0) {
		printf("listen - No Peer Context Available\n");
	} else {
		printf("listen - Peer Context: %s\n", peer_context);
		free(peer_context);
	}

	while (1) {
		sin_size = sizeof(struct sockaddr_in);

		new_sock = accept(sock, (struct sockaddr *)&client_addr,
				     &sin_size);
		if (new_sock < 0) {
			perror("Server accept");
			continue;
		}

		/* Get context assigned to the new socket */
		if (fgetfilecon_raw(new_sock, &context) < 0) {
			perror("fgetfilecon - FAILED");
			exit(1);
		}
		printf("accept on new socket - context assigned to new ");
		printf("socket is (using  fgetfilecon):\n\t%s\n", context);
		free(context);

		/* Then check if peer context is assigned to this new socket */
		if (getpeercon(new_sock, &peer_context) < 0) {
			printf("accept new socket - No Peer Context Available\n");
		} else {
			printf("accept new socket - Peer Context: %s\n",
				peer_context);
			free(peer_context);
		}

		/* Get Server context information */
		if (getcon(&context) < 0) {
			perror("Server context");
			exit(1);
		}

		if (getpeercon(new_sock, &peer_context) < 0) {
			peer_context_str = strdup("No Peer Context Available");
		} else {
			peer_context_str = strdup(peer_context);
			free(peer_context);
		}
		/* Clear the buffer of rubbish */
		memset(buffer, 0, sizeof(buffer));

		/* Print Server network information */
		printf("Server has connection from client: host = %s "
			"destination port = %s source port = %d\n",
			inet_ntoa(client_addr.sin_addr),
			argv[1], ntohs(client_addr.sin_port));

		printf("Server Context: %s\nServer Peer Context: %s\n",
			context, peer_context_str);

		/* Now send the buffer. */
		sprintf(buffer, "This is Message-%d from the server listening "
			"on port: %s\nClient source port: %d\n"
			"Server Context: %s\nServer Peer Context: %s\n",
			message_id, argv[1],
			ntohs(client_addr.sin_port),
			context, peer_context_str);

		if (send(new_sock, buffer, strlen(buffer), 0) < 0)
			perror("Server send");

		message_id++;
		free(context);
		free(peer_context_str);
		close(new_sock);
	}

	exit(0);
}
