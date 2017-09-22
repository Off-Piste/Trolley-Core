//
//  TRLWebSocketConnection.h
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
#import "TSRWebSocket.h"

@protocol TRLWebSocketDelegate;
@class TRLNetworkInfo;

@interface TRLWebSocketConnection : NSObject<TSRWebSocketDelegate>

@property (nonatomic, weak) id<TRLWebSocketDelegate> delegate;

- (id)initWith:(TRLNetworkInfo *)url
         queue:(dispatch_queue_t)queue
lastConnectionID:(NSString *)connectionID;

- (void)open;
- (void)close;
- (void)send:(NSDictionary *)dictionary;

- (void)webSocket:(TSRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocketDidOpen:(TSRWebSocket *)webSocket;
- (void)webSocket:(TSRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(TSRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

@protocol TRLWebSocketDelegate <NSObject>

- (void)onMessage:(TRLWebSocketConnection *)twebSocket withMessage:(NSDictionary *)message;
- (void)onDisconnect:(TRLWebSocketConnection *)twebSocket wasEverConnected:(BOOL)everConnected;

@end
