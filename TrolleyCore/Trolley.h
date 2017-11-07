//
//  Trolley.h
//  Trolley
//
//  Created by Harry Wright on 18.09.17.
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

#import <Foundation/Foundation.h>

@class TRLNetworkManager;

/********************************************************************
 *                                                                  *
 * Trolley.h contains the important `private` methods               *
 * and constants that are to be used only by Swift classes          *
 * or our SDK's and by no one else.                                 *
 *                                                                  *
 * trl_get_network_manager() gets the shared TRLNetworkManager      *
 *      - To be used by:                                            *
 *          * Analytics                                             *
 *          * Database                                              *
 *                                                                  *
 * _trl_network_manager_send_dictionary(NSDictionary, BOOL)         *
 * sends the contents of the NSDictionary to the network.           *
 *      - To be used by:                                            *
 *          * Analytics                                             *
 *                                                                  *
 ********************************************************************/

/**
 Notification to be sent when the Shop is started up

 :nodoc:
 */
//__attribute__((visibility("hidden")))
extern NSNotificationName TRLTrolleyStartingUpNotification;

/**
 @warning Please do not mutate, this is for internal purposes,
          changes can be done via Trolley/Auth

 :nodoc:
 */
__attribute__((visibility("hidden")))
extern NSString *AppleDeviceUUIDKey;

/**
 Function to get the devices Trolley UUID
 :nodoc:
 */
__attribute__((visibility("hidden")))
extern NSString *trl_device_uuid_get(void);

/**
 Function send the NSDictionary to the shared network
 :nodoc:
 */
//__attribute__((visibility("hidden")))
extern void _trl_network_manager_send_dictionary(NSDictionary *dictionary, BOOL secure);
