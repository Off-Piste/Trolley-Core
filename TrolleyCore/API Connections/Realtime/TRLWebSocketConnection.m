//
//  TRLWebSocketConnection.m
//  TrolleyCore
//
//  Created by Harry Wright on 21.09.17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "TRLWebSocketConnection.h"
#import "TRLNetworkInfo.h"
#import "TRLJSON.h"
#import "TRLJSONBase_Dynamic.h"
#import "Log.h"

#import <TrolleyCore/TrolleyCore-Swift.h>

static NSString *kLastSessionUDKey = @"";

@interface TRLWebSocketConnection () {
    NSMutableString* frame;
    BOOL everConnected;
    BOOL isClosed;
    NSTimer* keepAlive;
}

@property (nonatomic, readwrite) int totalFrames;
@property (nonatomic, readonly) BOOL buffering;
@property (nonatomic, strong) TSRWebSocket* webSocket;
@property (nonatomic, strong) NSString* connectionId;
@property (nonatomic) dispatch_queue_t dispatchQueue;

- (void)shutdown;
- (void)onClosed;
- (void)closeIfNeverConnected;
- (void)nop:(NSTimer *)timer;

@end

@implementation TRLWebSocketConnection

@synthesize delegate;
@synthesize webSocket;

- (id)initWith:(TRLNetworkInfo *)url queue:(dispatch_queue_t)queue lastConnectionID:(NSString *)connectionID {
    if (self = [super init]) {
        everConnected = NO;
        isClosed = NO;
        self.totalFrames = 0;
        self.dispatchQueue = queue;
        frame = nil;
        self.connectionId = connectionID;

        NSURLRequest *req = [NSURLRequest requestWithURL:
                             [url connectionURLWithLastSessionID:connectionID]];
        NSString *ua = [UserAgent shared].header;

        TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) Connecting to: %@ as %@",
                       connectionID, req.URL, ua);

        self.webSocket = [[TSRWebSocket alloc] initWithURLRequest:req userAgent:ua];
        [self.webSocket setDelegateDispatchQueue:queue];
        [self.webSocket setDelegate:self];
    }
    return self;
}

- (void)open {
    TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) FWebSocketConnection open.", self.connectionId);
    assert(delegate);
    everConnected = NO;

    [self.webSocket open];

    NSTimeInterval kWebsocketConnectTimeout = [TRLWebSocketUtils kWebsocketConnectTimeout];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, kWebsocketConnectTimeout * NSEC_PER_SEC);
    dispatch_after(when, self.dispatchQueue, ^{
        [self closeIfNeverConnected];
    });
}

- (void) close {
    TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) FWebSocketConnection is being closed.", self.connectionId);
    isClosed = YES;
    [self.webSocket close];
}

- (void)send:(NSDictionary *)dictionary {
    [self resetKeepAlive];

    NSData *jsonData = [[TRLJSON object:dictionary] rawDataWithError:nil];
    NSString *data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSUInteger kWebsocketMaxFrameSize = [TRLWebSocketUtils kWebsocketMaxFrameSize];
    NSArray<NSString *>* dataSegs = [data splitStringIntoMaxSize:kWebsocketMaxFrameSize];

    // First send the header so the server knows how many segments are forthcoming
    if (dataSegs.count > 1) {
        [self.webSocket send:[NSString stringWithFormat:@"%u", (unsigned int)dataSegs.count]];
    }

    // Then, actually send the segments.
    for(NSString * segment in dataSegs) {
        [self.webSocket send:segment];
    }
}

#pragma mark -
#pragma mark TRWebSocketDelegate implementation

- (void)webSocketDidOpen:(TSRWebSocket *)webSocket {
    TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) webSocketDidOpen", self.connectionId);

    everConnected = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval kWebsocketKeepAliveInterval = [TRLWebSocketUtils kWebsocketKeepAliveInterval];
        self->keepAlive = [NSTimer scheduledTimerWithTimeInterval:kWebsocketKeepAliveInterval
                                                           target:self
                                                         selector:@selector(nop:)
                                                         userInfo:nil
                                                          repeats:YES];
        TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) nop timer kicked off", self.connectionId);
    });
}

- (void)webSocket:(TSRWebSocket *)webSocket didReceiveMessage:(id)message {
    [self handleIncomingFrame:message];
}

- (void)webSocket:(TSRWebSocket *)webSocket didFailWithError:(NSError *)error {
    TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) %s %@", self.connectionId, __FUNCTION__, error);
    [self onClosed];
}

- (void)webSocket:(TSRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) %s %ld %@",
                   self.connectionId, __FUNCTION__, code, reason);
    
    [self onClosed];
}

#pragma mark -
#pragma mark Message handler methods & Utils

- (void) nop:(NSTimer *)timer {
    if (!isClosed) {
        TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) nop", self.connectionId);
        [self.webSocket send:@"0"];
    }
    else {
        TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) No more websocket; invalidating nop timer.", self.connectionId);
        [timer invalidate];
    }
}

- (void)handleNewFrameCount:(int) numFrames {
    self.totalFrames = numFrames;
    frame = [[NSMutableString alloc] initWithString:@""];
    TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) %s %d",
                   self.connectionId, __FUNCTION__, self.totalFrames);
}

- (NSString *)extractFrameCount:(NSString *) message {
    if ([message length] <= 4) {
        int frameCount = [message intValue];
        if (frameCount > 0) {
            [self handleNewFrameCount:frameCount];
            return nil;
        }
    }
    [self handleNewFrameCount:1];
    return message;
}

- (void)appendFrame:(NSString *) message {
    [frame appendString:message];
    self.totalFrames = self.totalFrames - 1;

    if (self.totalFrames == 0) {
        // Call delegate and pass an immutable version of the frame
//        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[frame dataUsingEncoding:NSUTF8StringEncoding]
//                                                             options:kNilOptions
//                                                               error:nil];


        TRLJSON *trljson = [[TRLJSON alloc] initWithData:[frame dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary* json = TRLJSONBaseRawValueForType(trljson, JSONTypeDictionary);

        frame = nil;
        TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) handleIncomingFrame sending complete frame: %d", self.connectionId, self.totalFrames);

        @autoreleasepool {
            [self.delegate onMessage:self withMessage:json];
        }
    }
}

- (void)handleIncomingFrame:(NSString *) message {
    [self resetKeepAlive];
    if (self.buffering) {
        [self appendFrame:message];
    } else {
        NSString *remaining = [self extractFrameCount:message];
        if (remaining) {
            [self appendFrame:remaining];
        }
    }
}

#pragma mark -
#pragma mark Private methods

- (void) closeIfNeverConnected {
    if (!everConnected) {
        TRLDebugLogger(TRLLoggerServiceCore, @" Websocket timed out on connect", self.connectionId);
        [self.webSocket close];
    }
}

- (void) shutdown {
    isClosed = YES;

    // Call delegate methods
    [self.delegate onDisconnect:self wasEverConnected:everConnected];

}

- (void) onClosed {
    if (!isClosed) {
        TRLDebugLogger(TRLLoggerServiceCore, @"Websocket is closing itself");
        [self shutdown];
    }
    self.webSocket = nil;
    if (keepAlive.isValid) {
        [keepAlive invalidate];
    }
}

- (void) resetKeepAlive {
    NSTimeInterval kWebsocketKeepaliveInterval = [TRLWebSocketUtils kWebsocketKeepAliveInterval];
    NSDate* newTime = [NSDate dateWithTimeIntervalSinceNow:kWebsocketKeepaliveInterval];

    // Calling setFireDate is actually kinda' expensive,
    // so wait at least 5 seconds before updating it.

    if ([newTime timeIntervalSinceDate:keepAlive.fireDate] > 5) {
        TRLDebugLogger(TRLLoggerServiceCore, @"(wsc:%@) resetting keepalive, to %@ ; old: %@", self.connectionId, newTime, [keepAlive fireDate]);
        [keepAlive setFireDate:newTime];
    }
}

@end
