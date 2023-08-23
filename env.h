
#ifndef MONGO_ENV_H_
#define MONGO_ENV_H_

#include "mongo.h"

MONGO_EXTERN_C_START

/* This is a no-op in the generic implementation. */
int mongo_env_set_socket_op_timeout( mongo *conn, int millis );
int mongo_env_read_socket( mongo *conn, void *buf, int len );
int mongo_env_write_socket( mongo *conn, const void *buf, int len );
int mongo_env_socket_connect( mongo *conn, const char *host, int port );

/* Initialize socket services */
MONGO_EXPORT int mongo_env_sock_init( void );

/* Close a socket */
MONGO_EXPORT int mongo_env_close_socket( int socket );

MONGO_EXTERN_C_END
#endif
