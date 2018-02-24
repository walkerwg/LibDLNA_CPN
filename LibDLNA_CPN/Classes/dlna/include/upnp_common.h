#ifndef _UPNP_COMMON_H_
#define _UPNP_COMMON_H_

#include "upnp_typedef.h"

#ifdef __cplusplus
extern "C"
{
#endif
/**
 * Version Date.
 */
extern const char *VERDATE;
/**
 * Version.
 */
extern const char *VERLIB;


/**
 * @file
 * @ingroup highlevelapi
 * Upnp common module provides a high level interface to access stack
 */
 


/**
 * Init stack.<br/>
 * It must be called  firstly. The stack must be shutdown with UPNP_Finish.
 *
 * @param path The home directory of the stack.<br/>
 * The stack may save configuration and local database items to this directory.<br/>
 * All device description files are in directory "MediaServer". The directory "MediaServer" is in this directory.
 * @param ip The IP address to use, in string format, for example "192.168.2.1", or NULL to use the first adapter's IP address.
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_Init(const char *path, const char *ip);


/**
 * Stop stack.<br/>
 * The stack must be shutdown with UPNP_Finish.
 *
 * @return 0 if successful, otherwise a error code.
 */
int UPNP_Finish(void);

/**
 * Get stack state currently.<br/>
 * 
 *
 * @return 0 if normal, otherwise a error code.
 */
int UPNP_GetState(void);

/**
 * Get current ip used.<br/>
 * 
 *
 * @return 0 if normal, otherwise a error code.
 */
void UPNP_GetIP(char *ip);

/**
 * Test stack.<br/>
 *
 * @return 0 if successful, otherwise a error code.
 */
char *UPNP_TestStart(int type, const char *data);
    
#ifdef __cplusplus
}
#endif
        
#endif
