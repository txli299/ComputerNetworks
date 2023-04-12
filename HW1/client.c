/**
 ** client.c  -  a server program that uses the socket interface to tcp 
 **
 **/

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include "client.h"

extern char *inet_ntoa( struct in_addr );

#define NAMESIZE		255
#define BUFSIZE			81

void client( int server_number, char *server_node )
{
int			length;
int			n, m, len;
bool		flag; //Used to tell if write or read
short			fd;
struct sockaddr_in	address;
struct hostent		*node_ptr;
char			local_node[NAMESIZE];
char			buffer[BUFSIZE];
char 			reply[BUFSIZE];

/*  get the internet name of the local host node on which we are running  */
if( gethostname( local_node, NAMESIZE ) < 0 )
	{
	perror( "client gethostname" );
	exit(1);
	}
fprintf(stderr, "client running on node %s\n", local_node);

/*  get the name of the remote host node on which we hope to find server  */
if( server_node == NULL )
	server_node = local_node;
fprintf(stderr, "client about to connect to server at port number %d on node %s\n",
		server_number, server_node);

/*  get structure for remote host node on which server resides  */
if( (node_ptr = gethostbyname( server_node )) == NULL )
	{
	perror( "client gethostbyname" );
	exit(1);
	}

/*  set up Internet address structure for the server  */
memset(&address, 0, sizeof(address));
address.sin_family = AF_INET;
memcpy(&address.sin_addr, node_ptr->h_addr, node_ptr->h_length);
address.sin_port = htons(server_number);

fprintf(stderr, "client full name of server node %s, internet address %s\n",
		node_ptr->h_name, inet_ntoa(address.sin_addr));

/*  open an Internet tcp socket  */
if( (fd = socket(AF_INET, SOCK_STREAM, 0)) < 0 )
	{
	perror( "client socket" );
	exit(1);
	}

/*  connect this socket to the server's Internet address  */
if( connect( fd, (struct sockaddr *)&address, sizeof(address) ) < 0 )
	{
	perror( "client connect" );
	exit(1);
	}

/*  now find out what local port number was assigned to this client  */
len = sizeof(address);
if( getsockname( fd, (struct sockaddr *)&address, &length ) < 0 )
	{
	perror( "client getsockname" );
	exit(1);
	}

/*  we are now successfully connected to a remote server  */
fprintf(stderr, "client at internet address %s, port %d\n",
		inet_ntoa(address.sin_addr), ntohs(address.sin_port));

/*  transmit data from standard input to server  */

// Start, the client will start the conversation
flag = true;
printf("System: The other is waiting for your writing!(x to give control, xx to quit)\n");
while(1)
{
	if(flag && fgets( buffer, BUFSIZE, stdin ) != NULL) //Write
	{
		len = strlen(buffer);
		n = send(fd, buffer, len, 0);
		if( n < 0 )
		{
			perror( "client send" );
			exit(1);
		}
		if(n!=len)
		{
			fprintf(stderr, "client sent %d bytes, attempted %d\n", n, len);
			break;
			}

		if(strcmp(buffer,"x\n")==0)
		{	
			printf("\nSystem: You are giving the control...\n");
			flag =false;
		}
		if(strcmp(buffer,"xx\n")==0)
		{
			printf("System: CHAT ENDS.\n");
			break;
		}

		if((m = recv(fd, reply, BUFSIZE, 0)) > 0){
			fputs(reply, stdout);
		}

	}
	if(!flag && (n = recv(fd, buffer, BUFSIZE, 0)) > 0){
		buffer[n] = '\0';
		n--;
		if( buffer[n] == '\n' )
			n--;
		if(strcmp(buffer,"xx\n")==0)
		{
			printf("System: Chat ends by the other speaker, Goodbye!\n");
			break;
		}
		if(strcmp(buffer,"x\n")==0)
		{
			printf("\nSystem: The other is waiting for your writing!\n");
			flag = true;
		}
		
		else{
			printf("The other speaker says: ");
			fputs(buffer, stdout);

		}
	}
	
}



/*  close the connection to the server  */
if( close(fd) < 0 )
	{
	perror( "client close" );
	exit(1);
	}
}
