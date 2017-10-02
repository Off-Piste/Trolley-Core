//
//  TRLNetworkConnection.h
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

#import <Foundation/Foundation.h>

#import "TRLWebSocketConnection.h"

@class TRLNetwork;
@protocol TRLNetworkConnectionDelegate;

typedef enum {
    DISCONNECT_REASON_SERVER_RESET = 0,
    DISCONNECT_REASON_OTHER = 1
} TRLDisconnectReason;

@interface TRLNetworkConnection : NSObject <TRLWebSocketDelegate>

@property (nonatomic, weak) id<TRLNetworkConnectionDelegate> delegate;

- (instancetype)initWithNetwork:(TRLNetwork *)network
               andDispatchQueue:(dispatch_queue_t)queue
                     deviceUUID:(NSString *)deviceId;

- (void)open;
- (void)close;
- (void)sendRequest:(NSDictionary *)dataMsg sensitive:(BOOL)sensitive;

- (void)onMessage:(TRLWebSocketConnection *)twebSocket withMessage:(NSDictionary *)message;
- (void)onDisconnect:(TRLWebSocketConnection *)twebSocket wasEverConnected:(BOOL)everConnected;

@end

@protocol TRLNetworkConnectionDelegate <NSObject>

- (void)onReady:(TRLNetworkConnection *)trlNetworkConnection;

- (void)onDataMessage:(TRLNetworkConnection *)trlNetworkConnection
          withMessage:(NSDictionary *)message;

- (void)onDisconnect:(TRLNetworkConnection *)trlNetworkConnection
          withReason:(TRLDisconnectReason)reason;

- (void)onKill:(TRLNetworkConnection *)trlNetworkConnection
    withReason:(NSString *)reason;

@end
