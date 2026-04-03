# MulleWebServer Library Documentation for AI

## 1. Introduction & Purpose

**MulleWebServer** provides a high-level web server abstraction built on MulleCivetWeb, offering simplified APIs for common server tasks like routing, middleware, and request handling. It reduces boilerplate for building REST APIs and web applications.

This library is particularly useful for:
- Building REST APIs with minimal setup
- Web application development
- Microservices and lightweight servers
- Development/testing HTTP servers
- Embedded web interfaces

## 2. Key Concepts & Design Philosophy

- **Request Routing**: Simple route matching and dispatching
- **Middleware Support**: Request/response processing pipeline
- **Handler Delegates**: Clean separation of concerns
- **Easy Setup**: Minimal configuration needed
- **Built on MulleCivetWeb**: Leverages proven HTTP server

## 3. Core API & Data Structures

### Server: `MulleWebServer`

#### Initialization

- `- (instancetype) initWithPort:(NSUInteger)port`
  - Create server on specified port
  - Starts listening immediately

#### Routing

- `- (void) addRoute:(NSString *)path handler:(MulleWebRequestHandler)handler`
  - Register handler for path
  - Supports parameterized routes

#### Request Handling

- `- (MulleCivetWebResponse *) handleRequest:(MulleCivetWebRequest *)request`
  - Route request to appropriate handler

#### Server Control

- `- (void) start`
  - Start server if not running

- `- (void) stop`
  - Shutdown server

- `- (BOOL) isRunning`
  - Check if server active

## 4. Performance Characteristics

- **Request Routing**: O(n) where n = number of routes
- **Throughput**: Same as underlying MulleCivetWeb
- **Startup**: < 100ms typical
- **Memory**: Minimal overhead over base server

## 5. Integration Examples

### Example 1: Simple REST API
```objc
MulleWebServer *server = [[MulleWebServer alloc] initWithPort:8080];

[server addRoute:@"/api/users" handler:^(MulleCivetWebRequest *req) {
    return [MulleCivetWebResponse responseWithJSON:@[@{@"id": @1, @"name": @"Alice"}]];
}];

[server start];
```

### Example 2: Parameterized Routes
```objc
[server addRoute:@"/api/users/{id}" handler:^(MulleCivetWebRequest *req) {
    NSString *userID = [req parameterForKey:@"id"];
    // Fetch user by ID
}];
```

### Example 3: Middleware Chain
```objc
[server addMiddleware:^(MulleCivetWebRequest *req, MulleCivetWebResponse *res, void(^next)()) {
    // Auth check
    if (![self isAuthenticated:req]) {
        res.status = 401;
        return;
    }
    next();
}];
```

## 6. Dependencies

- **MulleCivetWeb** - HTTP server
- **MulleFoundation** - NSString, NSDictionary
- **mulle-objc** (runtime)

## 7. Version Information

MulleWebServer version macro: `MULLE_WEB_SERVER_VERSION`
