

#ifndef MONGO_MD5_H_
#define MONGO_MD5_H_


#include "bson.h"

typedef unsigned char mongo_md5_byte_t; /* 8-bit byte */
typedef unsigned int mongo_md5_word_t; /* 32-bit word */

/* Define the state of the MD5 Algorithm. */
typedef struct mongo_md5_state_s {
    mongo_md5_word_t count[2];  /* message length in bits, lsw first */
    mongo_md5_word_t abcd[4];       /* digest buffer */
    mongo_md5_byte_t buf[64];       /* accumulate block */
} mongo_md5_state_t;

#ifdef __cplusplus
extern "C"
{
#endif

    /* Initialize the algorithm. */
    MONGO_EXPORT void mongo_md5_init(mongo_md5_state_t *pms);

    /* Append a string to the message. */
    MONGO_EXPORT void mongo_md5_append(mongo_md5_state_t *pms, const mongo_md5_byte_t *data, int nbytes);

    /* Finish the message and return the digest. */
    MONGO_EXPORT void mongo_md5_finish(mongo_md5_state_t *pms, mongo_md5_byte_t digest[16]);

#ifdef __cplusplus
}  /* end extern "C" */
#endif

#endif /* MONGO_MD5_H_ */
