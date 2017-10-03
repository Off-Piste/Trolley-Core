//
//  Trolley.m
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

#import "Trolley.h"
#import "Log.h"
#import "TrolleyCore-Swift-Fixed.h"

NSNotificationName TRLTrolleyStartingUpNotification = @"io.trolley.startingUpNotification";

NSString *AppleDeviceUUIDKey = @"io.trolley.device_key";

static int device_key_length = 20;

static NSString *device_key(void) {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: device_key_length];

    for (int i=0; i<device_key_length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }

    return randomString;
}

NSString *trl_device_uuid_get() {
    NSError *error;
    TRLDefaultsManager *dm = [TRLDefaultsManager managerForKey:AppleDeviceUUIDKey];
    NSString *conectionID = [dm retriveObject:&error];

    if (error) {
        TRLErrorLogger(TRLLoggerServiceCore, @"%@, This error is to be expected on the first install of an app. If this persists please contact us!", error);
        conectionID = device_key();
        [dm setObject:conectionID];
    }
    return conectionID;


}
