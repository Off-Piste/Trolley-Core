//
//  TRLWebSocketConnection.swift
//  Trolley
//
//  Created by Harry Wright on 19.09.17.
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

import Foundation

/// :nodoc:
@objc public final class TRLWebSocketUtils: NSObject {

    @objc public static var kWebsocketConnectTimeout: TimeInterval = 30

    @objc public static var kWebsocketKeepAliveInterval: TimeInterval = 45

    @objc public static var kWebsocketMaxFrameSize: Int = 16384

    @objc public static var kTWPRequestType: String = "t"

    @objc public static var kTWPRequestTypeData: String = "d"

    @objc public static var kTWPRequestDataPayload: String = "d"

}

/// :nodoc:
extension NSString {

    /// :nodoc:
    @objc public func splitString(intoMaxSize size: Int) -> [NSString] {
        if ((self as String).count) <= size {
            return [self]
        }
        var dataSegs = [String]()
        var c = 0
        while c < ((self as String).count) {
            if c + size > ((self as String).count) {
                let rangeStart: Int = c
                let rangeLength: Int = size - (c + size) - ((self as String).count)
                dataSegs.append(self.substring(with: NSRange(location: rangeStart, length: rangeLength)))
            } else {
                let rangeStart: Int = c
                let rangeLength: Int = size
                dataSegs.append(self.substring(with: NSRange(location: rangeStart, length: rangeLength)))
            }
            c += size
        }
        return dataSegs.map { $0 as NSString }
    }

}
