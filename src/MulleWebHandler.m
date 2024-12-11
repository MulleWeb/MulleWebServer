//
//  MulleWebHandler.h
//  MulleWebServer
//
//  Created by Nat! on 22.03.20.
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "MulleWebHandler.h"

#import "import-private.h"


@interface MulleWebHandlerManager( MulleWebHandler) < MulleWebHandler>
@end


@implementation MulleWebHandlerManager

- (id) init
{
   struct mulle_allocator   *allocator;

   _lock     = [NSRecursiveLock new];

   // Can't use NSMutableDictionary as it won't notice that its is
   // protected by an external lock. Otherwise within the lock, we
   // would have to mulleGainAccess to it before accessing, which seems
   // cumbersome.


   allocator = MulleObjCInstanceGetAllocator( self);
   _mulle_map_init( &_handlers, 0, (void *) &_MulleObjCContainerCopyKeyRetainValueCallback, allocator);

   return( self);
}


- (void) dealloc
{
   _mulle_map_done( &_handlers);
   [_lock release];

   [super dealloc];
}


- (MulleCivetWebResponse *)  manager:(MulleWebHandlerManager *) manager
            webResponseForWebRequest:(MulleCivetWebRequest *) request
                              server:(MulleCivetWebServer *) server
                                                MULLE_OBJC_THREADSAFE_METHOD
{
   return( nil);
}


- (MulleCivetWebResponse *) webServer:(MulleCivetWebServer *) server
             webResponseForWebRequest:(MulleCivetWebRequest *) request
                                                MULLE_OBJC_THREADSAFE_METHOD
{
   NSObject <MulleWebHandler>   *handler;
   MulleCivetWebResponse        *response;
   NSArray                      *components;
   NSString                     *key;
   NSURL                        *url;

   url        = [request URL];
   components = [url pathComponents];
   handler    = self;

   NSLockingDo( _lock)
   {
      for( key in components)
      {
         if( ! [key length])
            continue;

         handler = [handler handlerForKey:key];
         if( ! _isKeyValueCodingEnabled)
            break;
      }
   }

   response = [handler manager:self
      webResponseForWebRequest:request
                        server:server];

   return( response);
}


- (void) setHandler:(NSObject <MulleWebHandler> *) handler
             forKey:(NSString *) key
{
   NSLockingDo( _lock)
   {
      if( ! handler)
         _mulle_map_remove( &_handlers, key);
      else
         _mulle_map_set( &_handlers, key, handler);
   }
}


- (NSObject <MulleWebHandler> *) handlerForKey:(NSString *) key
{
   NSObject <MulleWebHandler>   *handler;

   NSLockingDo( _lock)
   {
      handler = _mulle_map_get( &_handlers, key);
      handler = [[handler retain] autorelease];
   }

   return( handler);
}

@end


@implementation NSObject( MulleWebHandler)

- (NSObject <MulleWebHandler> *) handlerForKey:(NSString *) key
{
   return( self);
}


- (MulleCivetWebResponse *)  manager:(MulleWebHandlerManager *) manager
            webResponseForWebRequest:(MulleCivetWebRequest *) request
                              server:(MulleCivetWebServer *) server
{
   NSString                        *printed;
   MulleCivetWebTextResponse       *response;
   MulleObjCBufferedOutputStream   *stream;

   switch( [request method])
   {
   case MulleHTTPGet  :
      if( ! [self respondsToSelector:@selector( mullePrintJSONToStream:)])
         break;

      response = [MulleCivetWebTextResponse webResponseForWebRequest:request];
      [response setHeaderValue:@"application/json"
                         forKey:MulleHTTPContentTypeKey];

      stream = [response createStreamAndSendHeaderData];
      [(id <MulleObjCPropertyListPrinting>) self mullePrintJSONToStream:stream];
      [stream mullePerformFinalize];  // flushes stream and disowns response
      // send trailing nil
      [response sendChunkedContentData];
      return( nil);
                    // sent this ourselves, thank you
   default :
      break;
   }

   return( [server webResponseForError:501
                      errorDescription:@"We don't do that here"
                         forWebRequest:request]);
}

@end