//
//   Copyright 2012 Square Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import <Foundation/Foundation.h>
#import <Security/SecCertificate.h>

typedef NS_ENUM(NSInteger, TSRReadyState) {
   TSR_CONNECTING   = 0,
   TSR_OPEN         = 1,
   TSR_CLOSING      = 2,
   TSR_CLOSED       = 3,
};

typedef enum TSRStatusCode : NSInteger {
   // 0–999: Reserved and not used.
   TSRStatusCodeNormal = 1000,
   TSRStatusCodeGoingAway = 1001,
   TSRStatusCodeProtocolError = 1002,
   TSRStatusCodeUnhandledType = 1003,
   // 1004 reserved.
   TSRStatusNoStatuTSReceived = 1005,
   TSRStatusCodeAbnormal = 1006,
   TSRStatusCodeInvalidUTF8 = 1007,
   TSRStatusCodePolicyViolated = 1008,
   TSRStatusCodeMessageTooBig = 1009,
   TSRStatusCodeMissingExtension = 1010,
   TSRStatusCodeInternalError = 1011,
   TSRStatusCodeServiceRestart = 1012,
   TSRStatusCodeTryAgainLater = 1013,
   // 1014: Reserved for future use by the WebSocket standard.
   TSRStatusCodeTLSHandshake = 1015,
   // 1016–1999: Reserved for future use by the WebSocket standard.
   // 2000–2999: Reserved for use by WebSocket extensions.
   // 3000–3999: Available for use by libraries and frameworks. May not be used by applications. Available for registration at the IANA via firstcome, firstserve.
   // 4000–4999: Available for use by applications.
} TSRStatusCode;

extern BOOL kLoggingEnabled;

@class TSRWebSocket;

extern NSString *const TSRWebSocketErrorDomain;
extern NSString *const TSRHTTPResponseErrorKey;

#pragma mark  TSRWebSocketDelegate

@protocol TSRWebSocketDelegate;

#pragma mark  TSRWebSocket

@interface TSRWebSocket : NSObject <NSStreamDelegate>

@property (nonatomic, weak) id <TSRWebSocketDelegate> delegate;

@property (nonatomic, readonly) TSRReadyState readyState;
@property (nonatomic, readonly, retain) NSURL *url;


@property (nonatomic, readonly) CFHTTPMessageRef receivedHTTPHeaders;

// Optional array of cookies (NSHTTPCookie objects) to apply to the connections
@property (nonatomic, readwrite) NSArray * requestCookies;

// This returns the negotiated protocol.
// It will be nil until after the handshake completes.
@property (nonatomic, readonly, copy) NSString *protocol;

// Protocols should be an array of strings that turn into SecWebSocketProtocol.
- (id)initWithURLRequest:(NSURLRequest *)request protocols:(NSArray *)protocols allowsUntrustedSSLCertificates:(BOOL)allowsUntrustedSSLCertificates;
- (id)initWithURLRequest:(NSURLRequest *)request protocols:(NSArray *)protocols;
- (id)initWithURLRequest:(NSURLRequest *)request;

- (instancetype)initWithURLRequest:(NSURLRequest *)request
                         userAgent:(NSString *)userAgent;

// Some helper constructors.
- (id)initWithURL:(NSURL *)url protocols:(NSArray *)protocols allowsUntrustedSSLCertificates:(BOOL)allowsUntrustedSSLCertificates;
- (id)initWithURL:(NSURL *)url protocols:(NSArray *)protocols;
- (id)initWithURL:(NSURL *)url;

// Delegate queue will be dispatch_main_queue by default.
// You cannot set both OperationQueue and dispatch_queue.
- (void)setDelegateOperationQueue:(NSOperationQueue*) queue;
- (void)setDelegateDispatchQueue:(dispatch_queue_t) queue;

// By default, it will schedule itself on +[NSRunLoop TTSR_networkRunLoop] using defaultModes.
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (void)unscheduleFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;

// TSRWebSockets are intended for onetimeuse only.  Open should be called once and only once.
- (void)open;

- (void)close;
- (void)closeWithCode:(NSInteger)code reason:(NSString *)reason;

// Send a UTF8 String or Data.
- (void)send:(id)data;

// Send Data (can be nil) in a ping message.
- (void)sendPing:(NSData *)data;

@end

#pragma mark  TSRWebSocketDelegate

@protocol TSRWebSocketDelegate <NSObject>

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(TSRWebSocket *)webSocket didReceiveMessage:(id)message;

@optional

- (void)webSocketDidOpen:(TSRWebSocket *)webSocket;
- (void)webSocket:(TSRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(TSRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void)webSocket:(TSRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;

// Return YES to convert messages sent as Text to an NSString. Return NO to skip NSData > NSString conversion for Text messages. Defaults to YES.
- (BOOL)webSocketShouldConvertTextFrameToString:(TSRWebSocket *)webSocket;

@end

#pragma mark  NSURLRequest (TSRCertificateAdditions)

@interface NSURLRequest (TSRCertificateAdditions)

@property (nonatomic, retain, readonly) NSArray *TSR_SSLPinnedCertificates;

@end

#pragma mark  NSMutableURLRequest (TSRCertificateAdditions)

@interface NSMutableURLRequest (TSRCertificateAdditions)

@property (nonatomic, retain) NSArray *TSR_SSLPinnedCertificates;

@end

#pragma mark  NSRunLoop (TSRWebSocket)

@interface NSRunLoop (TSRWebSocket)

+ (NSRunLoop *)TSR_networkRunLoop;

@end
