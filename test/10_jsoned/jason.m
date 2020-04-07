#import <MulleWebServer/MulleWebServer.h>
#import <MulleWebClient/MulleWebClient.h>
//#import <MulleCivetWeb/private/MulleCivetWebRequest+Private.h>

#include <stdlib.h>
#include <unistd.h>


static NSString   *URL = @"http://localhost:8080/foo";


@interface MyWebRequestHandler : NSObject <MulleCivetWebRequestHandler>
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


- (void) request:(id) server
{
   MulleCurl        *curl;
   NSDictionary     *headers;
   NSCharacterSet   *characterSet;
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
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return;
   }

   printf( "%s\n", [dictionary cStringDescription]);
}

@end


static char  *options[] =
{
   "num_threads", "1",
   NULL, NULL
};


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

   server  = nil;
   handler = [MyWebRequestHandler object];

   mode = argc == 2 ? argv[1][0] : 'b';

   if( mode == 's' || mode == 'b')
   {
      server  = [[[MulleCivetWebServer alloc] initWithCStringOptions:options] autorelease];
      [server setRequestHandler:handler];

      fprintf( stderr, "%s\n", [[server openPortInfos] cStringDescription]);

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
      thread = [[[NSThread alloc] initWithTarget:handler
                                        selector:@selector( request:)
                                          object:server] autorelease];
      //
      // need to wait for the server to be ready though...
      //
      fprintf( stderr, "starting curl...\n");
      [thread mulleStartUndetached];
      fprintf( stderr, "waiting for curl to finish...\n");
      [thread mulleJoin];
      fprintf( stderr, "done\n");

      // if we use the pedantic exit, then the server will have worker threads
      // still going. These will have retained the universe, so we will wait
      // indefinetely
   }

   [server mullePerformFinalize];

   return( 0);
}
