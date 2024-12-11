#import <MulleWebServer/MulleWebServer.h>
#import <MulleWebClient/MulleWebClient.h>
//#import <MulleCivetWeb/MulleCivetWebRequest+Private.h>

#include <stdlib.h>
#include <unistd.h>


static NSString   *URL = @"http://localhost:47254/foo";


static char  *options[] =
{
   "num_threads", "1",
   "listening_ports", "47254", // random ...
   NULL, NULL
};


@interface MyWebRequestHandler : MulleObject <MulleCivetWebRequestHandler,
                                              MulleAutolockingObjectProtocols>
@end


@implementation MyWebRequestHandler

- (MulleCivetWebResponse *) webServer:(MulleCivetWebServer *) server
             webResponseForWebRequest:(MulleCivetWebRequest *) request
{
   MulleCivetWebTextResponse   *response;
   NSURL                       *url;
   NSString                    *printed;
   NSDictionary                *headers;
   NSData                      *contentData;
   NSDictionary                *dictionary;

   url         = [request URL];
   contentData = [request contentData];

   response    = [MulleCivetWebTextResponse webResponseForWebRequest:request];
   [response setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]];
   // [response addToTransferEncodings:MulleHTTPTransferEncodingChunked];
   [response setHeaderValue:@"application/json"
                      forKey:MulleHTTPContentTypeKey];

   dictionary = @{ @"foo": @"bar" };
   printed    = [dictionary mulleJSONDescription];
   [response appendLine:printed];

   return( response);
}

@end


static int   requester( NSThread *thread, id server)
{
   MulleCurl        *curl;
   NSDictionary     *headers;
   NSDictionary     *dictionary;
   NSError          *error;

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
   MyWebRequestHandler      *handler;
   MulleCivetWebServer      *server;
   MulleCivetWebRequest     *request;
   NSData                   *contentData;
   int                      rval;
   NSDictionary             *headers;
   NSThread                 *thread;
   int                      mode;
   NSArray                 *info;

   server  = nil;
   handler = [MyWebRequestHandler object];

   mode = argc == 2 ? argv[1][0] : 'b';

   if( mode == 's' || mode == 'b')
   {
      server = [[[MulleCivetWebServer alloc] initWithCStringOptions:options] autorelease];
      if( ! server)
      {
         mulle_fprintf( stderr, "could not setup server\n");
         exit( 1);
      }

      [server setRequestHandler:handler];

      info = [server openPortInfos];
      if( ! info)
      {
         fprintf( stderr, "could not get server info\n");
         exit( 1);
      }

      mulle_fprintf( stderr, "%@\n", info);

      if( mode == 's')
      {
         mulle_fprintf( stderr, "CTRL-C to exit\n");
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
      //
      // need to wait for the server to be ready though...
      //
      mulle_fprintf( stderr, "starting curl...\n");
      [thread mulleStart];
      mulle_fprintf( stderr, "waiting for curl to finish...\n");
      [thread mulleJoin];
      mulle_fprintf( stderr, "done\n");

      // if we use the pedantic exit, then the server will have worker threads
      // still going. These will have retained the universe, so we will wait
      // indefinetely
   }

   [server mullePerformFinalize];

   return( 0);
}
