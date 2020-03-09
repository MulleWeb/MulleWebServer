#import "import.h"

#include <stdint.h>

/*
 *  (c) 2020 nat ORGANIZATION
 *
 *  version:  major, minor, patch
 */
#define MULLE_WEB_VERSION  ((0 << 20) | (7 << 8) | 56)


static inline unsigned int   MulleWeb_get_version_major( void)
{
   return( MULLE_WEB_VERSION >> 20);
}


static inline unsigned int   MulleWeb_get_version_minor( void)
{
   return( (MULLE_WEB_VERSION >> 8) & 0xFFF);
}


static inline unsigned int   MulleWeb_get_version_patch( void)
{
   return( MULLE_WEB_VERSION & 0xFF);
}


extern uint32_t   MulleWeb_get_version( void);

/*
   Add your library headers here for exposure to library
   consumers.
*/
// #import "MyClass.h"
#import "MulleJSMNParser+MulleCurlParser.h"
#import "MulleCurl+NSURL.h"
