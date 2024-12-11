# MulleWebServer

#### 🤽🏻‍♂️ Web Server based on civetweb for mulle-objc

This is a small WebServer library written on top of the MulleFoundation.

It contains an HTTP server and support for JSON. It is experimental at this stage.




| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleWeb/MulleWebServer.svg) [![Build Status](https://github.com/MulleWeb/MulleWebServer/workflows/CI/badge.svg)](//github.com/MulleWeb/MulleWebServer/actions) | [RELEASENOTES](RELEASENOTES.md) |





## Example

Serving a NSDictionary to the net can be done like this:


``` objc
//
// define a handler to service web requests, that answers
// http://<host>:8080/foo requests
//
@interface MyWebRequestHandler : MulleObject <MulleCivetWebRequestHandler,
                                              MulleAutolockingObjectProtocols>
@end


@implementation MyWebRequestHandler

- (MulleCivetWebResponse *) webServer:(MulleCivetWebServer *) server
             webResponseForWebRequest:(MulleCivetWebRequest *) request
{
   MulleCivetWebTextResponse   *response;
   NSDictionary                *dictionary;

   if( [[[request URL] path] isEqualToString:@"foo"])
   {
      response   = [MulleCivetWebTextResponse webResponseForWebRequest:request];
      dictionary = @{ @"foo": @"VfL Bochum 1848" };
      [response appendLine:[dictionary mulleJSONDescription]];

      return( response);
   }
   return( nil);
}

@end


int  main( void)
{
   MyWebRequestHandler   *handler;
   MulleCivetWebServer   *server;

   // install request handler in server
   handler = [MyWebRequestHandler object];
   server  = [MulleCivetWebServer object];
   [server setRequestHandler:handler];

   // let server run until CTRL-C or signal
   for(;getchar() != 'q';);

   return( 0);
}
```

> This library ties MulleCivetWebServer to MulleObjCOSFoundation
> to gain logging functionality.





### You are here

![Overview](overview.dot.svg)


## Add

Use [mulle-sde](//github.com/mulle-sde) to add MulleWebServer to your project:

``` sh
mulle-sde add github:MulleWeb/MulleWebServer
```

## Install

### Install with mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleWebServer and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com//MulleWebServer/archive/latest.tar.gz
```

### Manual Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [MulleCivetWeb](https://github.com/MulleWeb/MulleCivetWeb)             | 🦊 HTTP Server for mulle-objc
| [MulleObjCJSMNFoundation](https://github.com/MulleWeb/MulleObjCJSMNFoundation)             | 🌼 JSON support for mulle-objc
| [MulleFoundation](https://github.com/MulleFoundation/MulleFoundation)             | 💍 Umbrella library for the MulleFoundation
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list)             | 📒 Lists mulle-objc runtime information contained in executables.

Download the latest [tar](https://github.com/MulleWeb/MulleWebServer/archive/refs/tags/latest.tar.gz) or [zip](https://github.com/MulleWeb/MulleWebServer/archive/refs/tags/latest.zip) archive and unpack it.

Install **MulleWebServer** into `/usr/local` with [cmake](https://cmake.org):

``` sh
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_PREFIX_PATH=/usr/local \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```

### Platforms and Compilers

All platforms and compilers supported by
[mulle-c11](//github.com/mulle-c/mulle-c11).


## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  

