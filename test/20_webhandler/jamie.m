#import <MulleWebServer/MulleWebServer.h>
#import <MulleWebClient/MulleWebClient.h>

//#import <MulleCivetWeb/MulleCivetWebRequest+Private.h>

#include <stdlib.h>
#include <unistd.h>


static NSString   *URL = @"http://localhost:47255/foo";


static char  *options[] =
{
   "num_threads", "1",
   "listening_ports", "47255", // random ...
   NULL, NULL
};


@interface MyWebHandler : MulleObject <MulleWebHandler>
@end


@implementation MyWebHandler

- (MulleCivetWebResponse *)  manager:(MulleWebHandlerManager *) manager
            webResponseForWebRequest:(MulleCivetWebRequest *) request
                              server:(MulleCivetWebServer *) server
{
   NSString                        *printed;
   MulleCivetWebTextResponse       *response;
   MulleObjCBufferedOutputStream   *stream;
   NSDictionary                    *plist;

   switch( [request method])
   {
   case MulleHTTPGet  :
      response = [MulleCivetWebTextResponse webResponseForWebRequest:request];
      [response setHeaderValue:@"application/json"
                         forKey:MulleHTTPContentTypeKey];

      stream = [response createStreamAndSendHeaderData];
      plist  = @{ @"foo": @"bar" };
      [plist mullePrintJSONToStream:stream];
      [stream flush];
      [response sendChunkedContentData]; // send of of data
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


static int   requester( NSThread *thread, id server)
{
   MulleCurl      *curl;
   NSDictionary   *headers;
   NSDictionary   *dictionary;
   NSError        *error;

   while( server && ! [server isReady])
   {
      fprintf( stderr, "waiting for server to become ready...");
      sleep( 1);
   }

   [MulleCurl setDefaultUserAgent:@"test"];
   dictionary = [MulleCurl JSONContentsOfURLWithString:URL];
   if( ! dictionary)
   {
      error = [NSError mulleExtract];
      mulle_fprintf( stderr, "%@\n", error);
      return( 1);
   }

   mulle_printf( "%@\n", dictionary);
   return( 0);
}



int   main( int argc, char *argv[])
{
   MulleCivetWebServer      *server;
   MulleCivetWebRequest     *request;
   NSData                   *contentData;
   int                      rval;
   NSDictionary             *headers;
   NSThread                 *thread;
   int                      mode;
   MulleWebHandlerManager   *manager;
   MyWebHandler             *handler;

   server  = nil;
   mode    = argc == 2 ? argv[1][0] : 'b';

   [[NSThread mainThread] mulleSetNameUTF8String:"main"];

   if( mode == 's' || mode == 'b')
   {
      server  = [[[MulleCivetWebServer alloc] initWithCStringOptions:options] autorelease];
      manager = [MulleWebHandlerManager object];
      handler = [MyWebHandler object];
      [manager setHandler:handler
                   forKey:@"foo"];

      [server setRequestHandler:manager];

      mulle_fprintf( stderr, "%@\n", [server openPortInfos]);

      if( mode == 's')
      {
         fprintf( stderr, "CTRL-C to exit\n");
         for(;;)
         {
            sleep( 100);
         }
      }
   }

   //
   // chance to try with curl from the outside
   // interestingly, Sublime Text broadcasts changes to files via :8080
   // so you may get some stray requests :)
   //
   if( mode == 'c' || mode == 'b')
   {
      //
      // "abuse" handler to also send the request via curl and http
      // to server ...
      //
      thread = [[[NSThread alloc] mulleInitWithObjectFunction:requester
                                                       object:server] autorelease];
      [thread mulleSetNameUTF8String:"requester"];
      //
      // need to wait for the server to be ready though...
      //
      fprintf( stderr, "starting curl...\n");
      [thread mulleStart];
      fprintf( stderr, "waiting for curl to finish...\n");
      [thread mulleJoin];
      fprintf( stderr, "done\n");

      // if we use the pedantic exit, then the server will have worker threads
      // still going. These will have retained the universe, so we will wait
      // indefinitely
   }

   [server mullePerformFinalize];

   return( 0);
}
