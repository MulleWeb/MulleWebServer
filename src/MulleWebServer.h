#import "import.h"

#include <stdint.h>

/*
 *  (c) 2020 nat ORGANIZATION
 *
 *  version:  major, minor, patch
 */
#define MULLE_WEB_SERVER_VERSION  ((0 << 20) | (0 << 8) | 4)


static inline unsigned int   MulleWebServer_get_version_major( void)
{
   return( MULLE_WEB_SERVER_VERSION >> 20);
}


static inline unsigned int   MulleWebServer_get_version_minor( void)
{
   return( (MULLE_WEB_SERVER_VERSION >> 8) & 0xFFF);
}


static inline unsigned int   MulleWebServer_get_version_patch( void)
{
   return( MULLE_WEB_SERVER_VERSION & 0xFF);
}


extern uint32_t   MulleWebServer_get_version( void);

/*
   Add your library headers here for exposure to library
   consumers.
*/
// #import "MyClass.h"
#import "MulleWebHandler.h"
#import "MulleCivetWebServer+OS.h"
