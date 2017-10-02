//
//  TRLNetwork.m
//  RequestBuilder
//
//  Created by Harry Wright on 30.08.17.
//  Copyright © 2017 Off-Piste.
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

#import "TRLNetwork.h"
#import "TRLNetwork_Private.h"

#import "TRLNetworkManager.h"

#import "TRLNetworkConnection.h"

#import "TRLParsedURL.h"

#import "TRLRequest.h"

#import "Log.h"
#import "Trolley.h"
#import "TrolleyCore-Swift-Fixed.h"

@implementation TRLNetwork {
    TRLNetworkConnection *connection;
    NSMutableSet *interruptReasons;
    NSTimeInterval lastConnectionEstablishedTime;
    BOOL firstConnect;
}

- (NSURL *)url {
    return self.parsedURL.url;
}

- (NSURL *)connectionURL {
    return self.parsedURL.connectionURL;
}

- (NSString *)description {
    return self->_parsedURL.description;
}

- (instancetype)initWithURLString:(NSString *)url manager:(TRLNetworkManager *)manager {
    self = [super init];
    if (self) {
        TRLDebugLogger(TRLLoggerServiceCore, @"Creating Network for url: @%", url);
        self->_parsedURL = [[TRLParsedURL alloc] initWithURLString:url];
        self->_manager = manager;
        self->_connectionState = ConnectionStateDisconnected;
        self->interruptReasons = [NSMutableSet set];

        self->_retryHelper = [[TRLRetryHelper alloc] initWithDispatchQueue:dispatch_get_main_queue()
                                                 minRetryDelayAfterFailure:1.0
                                                             maxRetryDelay:30.0
                                                             retryExponent:1.3f
                                                              jitterFactor:0.7];
    }
    return self;
}

- (TRLRequest *)get:(NSString *)path
         parameters:(Parameters *)parameters
           encoding:(id<TRLURLParameterEncoding>)encoding
            headers:(HTTPHeaders *)headers
{
    Parameters *_param = parameters ? parameters : @{}.copy;
    HTTPHeaders *_headers = headers ? headers : @{}.copy;

    NSURL *url = [self.url URLByAppendingPathComponent:path];
    return [[TRLRequest alloc] initWithURL:url.absoluteString
                                    method:HTTPMethodGET
                                parameters:_param
                                  encoding:encoding
                                   headers:_headers];
}

#pragma mark - Connection status

- (void)open {
    [self resumeForReason:@"waiting_for_open"];
}

- (BOOL)shouldReconnect {
    return self->interruptReasons.count == 0;
}

- (BOOL)connected {
    return self->_connectionState == ConnectionStateConnected;
}

- (BOOL)canSendWrites {
    return [self connected];
}

#pragma mark - Delegate

- (void)onReady:(TRLNetworkConnection *)trlNetworkConnection {
    lastConnectionEstablishedTime = [[NSDate date] timeIntervalSince1970];
    _connectionState = ConnectionStateConnected;

    if (firstConnect) {
        // Send queue
    }

    firstConnect = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.onConnect(self);
    });
}

- (void)onKill:(TRLNetworkConnection *)trlNetworkConnection
    withReason:(NSString *)reason
{
    TRLFaultLogger(TRLLoggerServiceCore, @"Trolley Network connection has been forcefully killed by the server. Will not attempt to reconnect. Reason:%@", reason);
    [self interruptForReason:@"server_kill"];
}

- (void)onDisconnect:(TRLNetworkConnection *)trlNetworkConnection
          withReason:(TRLDisconnectReason)reason
{
    _connectionState = ConnectionStateDisconnected;
    self->connection = nil;

    // Inform analytics to place requests in queue.

    if ([self shouldReconnect]) {
        if (reason == DISCONNECT_REASON_SERVER_RESET) {
            [_retryHelper signalSuccess];
        }
        [self tryScheduleReconnect];
    }

    self.onDisconnect(self);
}

- (void)onDataMessage:(TRLNetworkConnection *)trlNetworkConnection
          withMessage:(NSDictionary *)message {
    TRLLog(TRLLoggerServiceCore, @"%@", message);
}

- (void)dealloc {
    TRLLog(TRLLoggerServiceCore, @"%s", __FUNCTION__);
}

#pragma mark - Connection handling methods

- (void)interruptForReason:(NSString *)reason {
    TRLDebugLogger(TRLLoggerServiceCore, @"Connection interrupted for: %@", reason);
    [self->interruptReasons addObject:reason];

    if (self->connection) {
        [connection close];
        self->connection = nil;
    } else {
        [self->_retryHelper cancel];
        self->_connectionState = ConnectionStateDisconnected;
    }

    [_retryHelper signalSuccess];
}

- (void)resumeForReason:(NSString *)reason {
    TRLDebugLogger(TRLLoggerServiceCore, @"Connection no longer interrupted for: %@", reason);
    [interruptReasons removeObject:reason];

    if ([self shouldReconnect] && _connectionState == ConnectionStateDisconnected) {
        [self tryScheduleReconnect];
    }
}

- (BOOL)isInterruptedForReason:(NSString *)reason {
    return [interruptReasons containsObject:reason];
}

#pragma mark - Private

- (void)tryScheduleReconnect {
    if ([self shouldReconnect]) {
        NSAssert(self->_connectionState == ConnectionStateDisconnected, @"");

        TRLDebugLogger(TRLLoggerServiceCore, @"Scheduling connection attempt");
        [_retryHelper retryWithBlock:^{
            if (self.manager.reachability.currentReachabilityStatus == NotReachable) {
                TRLLog(TRLLoggerServiceCore, @"Network status is 'NotReachable', calling %s", __FUNCTION__);
                [self tryScheduleReconnect];
            }
            
            [self openNetworkConnection];
        }];
    }
}

- (void)openNetworkConnection {
    _connectionState = ConnectionStateConnecting;
    self->connection = [[TRLNetworkConnection alloc] initWithNetwork:self
                                                    andDispatchQueue:dispatch_get_main_queue()
                                                          deviceUUID:trl_device_uuid_get()];
    self->connection.delegate = self;
    [self->connection open];
}

- (void) enteringForeground {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Reset reconnect delay
        [_retryHelper signalSuccess];
        if (self->_connectionState == ConnectionStateDisconnected) {
            [self tryScheduleReconnect];
        }
    });
}

/**
 This is sent via TRLNetworkManager, if the network is not connected and its
 reachable should send connect.
 */
extern void trl_handle_for_reachabilty(id reach, TRLNetwork *network) {
    if ([reach isKindOfClass:[Reachability class]]) {
        if ([(Reachability *)reach currentReachabilityStatus] == NotReachable) { return; }
        TRLDebugLogger(TRLLoggerServiceCore, @"Network became reachable. Trigger a connection attempt");

        TRLNetwork *self = network;
        [self->_retryHelper signalSuccess];

        if (self->_connectionState == ConnectionStateDisconnected) {
            [self tryScheduleReconnect];
        }
    } else {
        [[NSException exceptionWithName:NSGenericException
                                 reason:@"Invalid object passed to trl_handle_for_reachabilty()"
                               userInfo:nil] reason];
    }
}

// TODO: - observers&listeners
#pragma mark observers&listeners

@end
