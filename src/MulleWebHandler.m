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
   _lock     = [NSLock new];
   _handlers = [NSMutableDictionary new];

   return( self);
}


- (void) dealloc
{
   [_handlers release];
   [_lock release];

   [super dealloc];
}


- (MulleCivetWebResponse *)  manager:(MulleWebHandlerManager *) manager
            webResponseForWebRequest:(MulleCivetWebRequest *) request
                              server:(MulleCivetWebServer *) server
{
   return( nil);
}


- (MulleCivetWebResponse *) webServer:(MulleCivetWebServer *) server
             webResponseForWebRequest:(MulleCivetWebRequest *) request
{
   NSObject <MulleWebHandler>   *handler;
   MulleCivetWebResponse        *response;
   NSArray                      *components;
   NSString                     *key;
   NSURL                        *url;

   url        = [request URL];
   components = [url pathComponents];
   handler    = self;

   [_lock lock];
   {
      for( key in components)
      {
         if( ! [key length])
            continue;
         handler = [handler valueForKey:key];
         if( ! _isKeyValueCodingEnabled)
            break;
      }
   }
   [_lock unlock];

   response = [handler manager:self
      webResponseForWebRequest:request
                        server:server];

   return( response);
}


- (void) setHandler:(NSObject <MulleWebHandler> *) handler
             forKey:(NSString *) key
{
   [_lock lock];
   {
      if( ! handler)
         [_handlers removeObjectForKey:key];
      else
         [_handlers setObject:handler
                       forKey:key];
   }
   [_lock unlock];
}


- (NSObject <MulleWebHandler> *) handlerForKey:(NSString *) key
{
   NSObject <MulleWebHandler>   *handler;

   [_lock lock];
   {
      handler = [_handlers objectForKey:key];
      handler = [[handler retain] autorelease];
   }
   [_lock unlock];

   return( handler);
}


// unlocked ! dangerous
- (id) valueForKey:(NSString *) key
{
   NSParameterAssert( ! [_lock tryLock]);

   return( [_handlers objectForKey:key]);
}

@end


@implementation NSObject( MulleWebHandler)

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