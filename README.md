# MulleWebServer

#### 🤽🏻‍♂️ Web Server based on civetweb for mulle-objc

This is a small WebServer library written on top of the MulleFoundation.

It contains an HTTP server and support for JSON. It is experimental at this stage.


Serving a NSDictionary to the net can be done like this:


```
//
// define a handler to service web requests, that answers
// http://<host>:8080/foo requests
//
@interface MyWebRequestHandler : NSObject <MulleCivetWebRequestHandler>
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


## Build

This is a [mulle-sde](https://mulle-sde.github.io/) project.

It has it's own virtual environment, that will be automatically setup for you
once you enter it with:

```
mulle-sde MulleWebServer
```

Now you can let **mulle-sde** fetch the required dependencies and build the
project for you:

```
mulle-sde craft
```
