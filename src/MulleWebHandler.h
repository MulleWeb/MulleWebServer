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
#import "import.h"


@class MulleWebHandlerManager;

// TODO: abstract this away from MulleCivetWeb if the need arises
@protocol MulleWebHandler

- (NSObject <MulleWebHandler> *) handlerForKey:(NSString *) key
                                          MULLE_OBJC_THREADSAFE_METHOD;

- (MulleCivetWebResponse *)  manager:(MulleWebHandlerManager *) manager
            webResponseForWebRequest:(MulleCivetWebRequest *) request
                              server:(MulleCivetWebServer *) server
                              MULLE_OBJC_THREADSAFE_METHOD;
@end


//
// use this class as the root MulleCivetWebRequestHandler to split off
// urls by the first path component into various handlers. As a bonus
// you can put in any object that responds to mulleJSONDescription
// and it will return itself as a JSON response
//
@interface MulleWebHandlerManager : MulleObject <MulleCivetWebRequestHandler, MulleWebHandler>
{
   NSRecursiveLock    *_lock;  // must serve multiple threads so....
   struct mulle_map   _handlers;
}

//
// instead of using the first path component to lookup the handler,
// the _handlers dictionary is traversed with the complete url path
// using KeyValueCoding "valueForKey:"
//
@property( setter=setKeyValueCodingEnabled:) BOOL   isKeyValueCodingEnabled;

// set "nil" to remove
//
// TODO: rename to setWebHandler:forKey:
//
- (void) setHandler:(NSObject <MulleWebHandler> *) handler
             forKey:(NSString *) key                              MULLE_OBJC_THREADSAFE_METHOD;
- (NSObject <MulleWebHandler> *) handlerForKey:(NSString *) key   MULLE_OBJC_THREADSAFE_METHOD;

@end


//
// any random object can be used as a handler, it will be asked for its JSON
// description, and this will be returned. As a bonus the plist will be
// streamed back, so the latency will be great even for very large
// responses.
//
@interface NSObject( MulleWebHandler) <MulleWebHandler>
@end
