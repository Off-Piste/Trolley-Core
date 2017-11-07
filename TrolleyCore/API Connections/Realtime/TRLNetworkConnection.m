//
//  TRLNetworkConnection.m
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

#import "TRLNetworkConnection.h"

#import "TRLNetwork_Private.h"
#import "TRLParsedURL.h"

#import <TrolleyCore/TrolleyCore-Swift.h>

typedef enum {
    REALTIME_STATE_CONNECTING = 0,
    REALTIME_STATE_CONNECTED = 1,
    REALTIME_STATE_DISCONNECTED = 2,
} TRLConnectionState;

static NSString *kLastConnectionIDUserDefaultsKey = @"";

/// Message filtering, checks if a message is of a control kind
/// i.e turning off the connection or handshaking or resetting connection
/// or just a default message of the kind, e.g:
///
/// {
///     "t" : "d",
///     "d" : {
///         "name" : "TRLDatabase_TRLItemOutOfStockNotfication",
///         "type" : "Notfication",
///         "attribues" : { "item" : "qwertyuiop1234567890" }
///     }
/// }
NSString *const kTWPAsyncServerEnvelopeType = @"t";
NSString *const kTWPAsyncServerEnvelopeData = @"d";
NSString *const kTWPAsyncServerControlMessage = @"c";
NSString *const kTWPAsyncServerControlMessageType = @"t";
NSString *const kTWPAsyncServerControlMessageData = @"d";
NSString *const kTWPAsyncServerDataMessage = @"d";
NSString *const kTWPAsyncServerControlMessageShutdown = @"s";

@interface TRLNetworkConnection () {
    TRLConnectionState _state;
}

@property (strong, nonatomic) TRLWebSocketConnection *connection;
@property (strong, nonatomic) TRLNetwork *network;

@end

@implementation TRLNetworkConnection

- (instancetype)initWithNetwork:(TRLNetwork *)network
               andDispatchQueue:(dispatch_queue_t)queue
                     deviceUUID:(NSString *)deviceId
{
    if (self = [super init]) {
        _state = REALTIME_STATE_CONNECTING;

        TRLNetworkInfo *info = [network.parsedURL info];
        self.network = network;
        self.connection = [[TRLWebSocketConnection alloc] initWith:info
                                                             queue:queue
                                                  lastConnectionID:deviceId];



        self.connection.delegate = self;
    }
    return self;
}

#pragma mark - Open NetworkConnection

- (void)open {
    TRLDebugLogger(TRLLoggerServiceCore, "Calling open in TRLNetworkConnection");
    [self.connection open];
}

#pragma mark - Close NetworkConnection

- (void)close {
    [self closeWithReason:DISCONNECT_REASON_OTHER];
}

- (void)closeWithReason:(TRLDisconnectReason)reason {
    if (_state != REALTIME_STATE_DISCONNECTED) {
        TRLDebugLogger(TRLLoggerServiceCore, "Closing realtime connection.");
        _state = REALTIME_STATE_DISCONNECTED;

        if (self.connection) {
            TRLDebugLogger(TRLLoggerServiceCore, "Deallocating TRLWebSocketConnection");
            [self.connection close];
            self.connection = nil;
        }

        [self.delegate onDisconnect:self withReason:reason];
    }
}

#pragma mark - Sending Data

- (void)sendRequest:(NSDictionary *)dataMsg sensitive:(BOOL)sensitive {
    NSDictionary *msg = @{
          [TRLWebSocketUtils kTWPRequestType]: [TRLWebSocketUtils kTWPRequestTypeData],
          [TRLWebSocketUtils kTWPRequestDataPayload]: dataMsg
    };
    [self send:msg sensitive:sensitive];
}

- (void)send:(NSDictionary *)dataMsg sensitive:(BOOL)sensitive {
    if (_state != REALTIME_STATE_CONNECTED) {
        @throw [NSException exceptionWithName:@"InvalidConnectionState"
                                       reason:@"Tried to send data on an unconnected TRLNetworkConnection"
                                     userInfo:nil];
    } else {
        if (sensitive) {
            TRLDebugLogger(TRLLoggerServiceCore, "Sending %{private}@", dataMsg);
        } else {
            TRLDebugLogger(TRLLoggerServiceCore, "Sending %@", dataMsg);

        }

        [self.connection send:dataMsg];
    }
}

#pragma mark - Delegate

- (void)onDisconnect:(TRLWebSocketConnection *)twebSocket wasEverConnected:(BOOL)everConnected {
    self.connection = nil;

    if (!everConnected && _state == REALTIME_STATE_CONNECTING) {
        TRLDebugLogger(TRLLoggerServiceCore, "Realtime connection failed.");
    } else if (_state == REALTIME_STATE_CONNECTED) {
        TRLDebugLogger(TRLLoggerServiceCore, "Realtime connection lost.");
    }

    [self close];
}

- (void)onMessage:(TRLWebSocketConnection *)twebSocket withMessage:(NSDictionary *)message {
    NSString *rawMessageType = message[kTWPAsyncServerEnvelopeType];
    if (rawMessageType != nil) {
        if ([rawMessageType isEqualToString:kTWPAsyncServerDataMessage]) {
            [self onDataMessage:message[kTWPAsyncServerEnvelopeData]];
        } else if ([rawMessageType isEqualToString:kTWPAsyncServerControlMessage]) {
            [self onControl:message[kTWPAsyncServerEnvelopeData]];
        } else {
            TRLDebugLogger(TRLLoggerServiceCore, "Unrecognized server packet type: %@", rawMessageType);
        }
    } else {
        TRLFaultLogger(TRLLoggerServiceCore, "Unrecognized raw server packet received: %@", message);
    }
}

#pragma mark - Handle Messages

/**
 Method to handle Data messages, TRLNetwork will handle these
 */
- (void) onDataMessage:(NSDictionary *)message {
    // we don't do anything with data messages, just kick them up a level
    TRLDebugLogger(TRLLoggerServiceCore, "Got data message: %@", message);
    [self.delegate onDataMessage:self withMessage:message];
}

/**
 Method to manage the control JSON, i.e. Shutdown and handshake
 */
- (void) onControl:(NSDictionary *)message {
    TRLDebugLogger(TRLLoggerServiceCore, "Got data message: %@", message);
    NSString *type = message[kTWPAsyncServerControlMessageType];

    if([type isEqualToString:kTWPAsyncServerControlMessageShutdown]) {
        NSString* reason = [message objectForKey:kTWPAsyncServerControlMessageData];
        [self onConnectionShutdownWithReason:reason];
    } if ([type isEqualToString:@"h"]) {
        NSTimeInterval ti = [[message objectForKey:@"ts"] doubleValue];
        [self on_valid_connetion_handshake:ti];
    } else {
        TRLDebugLogger(TRLLoggerServiceCore, "Invalid Control Message: %@", message);
    }
}

/**
 This is called only in very rare circumstances, this call should be noted
 higher up up the chain to stop any network calls been made and queue them
 up in the persistance storage (2.0.0+)

 @param reason The reason for the shutdown
 */
- (void)onConnectionShutdownWithReason:(NSString *)reason {
    TRLDebugLogger(TRLLoggerServiceCore, "Connection shutdown command received. Shutting down...");

    [self.delegate onKill:self withReason:reason];
    [self close];
}

/**
 This is my valid_connection_handshake, called only once the connection has passed
 its validation and means that the network is valid and your are connected
 */
- (void)on_valid_connetion_handshake:(NSTimeInterval)timeInterval {
    TRLDebugLogger(TRLLoggerServiceCore, "Recived valid handshake, at: %@",
           [NSDate dateWithTimeIntervalSince1970:timeInterval]);

    // Set the state to connected as we have passed the required validation
    // also when the delegate method is called the connection will be used
    _state = REALTIME_STATE_CONNECTED;

    [self.delegate onReady:self];
}


@end
