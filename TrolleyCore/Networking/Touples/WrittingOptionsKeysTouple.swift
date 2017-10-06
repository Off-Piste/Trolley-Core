/////////////////////////////////////////////////////////////////////////////////
//
//  WrittingOptionsKeysTouple.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 31.08.17.
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
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// :nodoc:
@objc(Key) public enum WrittingOptionsKeys: Int {
    case jsonSerialization = 0
    case castNilToNSNull
    case maxObjextDepth
    case encoding
}

/// :nodoc:
@objc final public class WrittingOptions: NSObject {

    /// :nodoc:
    @objc public var key: WrittingOptionsKeys

    /// :nodoc:
    @objc public var value: Any

    private override init() { fatalError() }

    /// :nodoc:
    @objc public init(withKey key: WrittingOptionsKeys, value: Any) {
        self.key = key
        self.value = value
    }

}

/// :nodoc:
public extension NSArray {

    // swiftlint:disable for_where
    /// :nodoc:
    @objc public func optionForKey(_ key: WrittingOptionsKeys) -> Any? {
        for option in self where option is WrittingOptions  {
            if (option as! WrittingOptions).key == key {
                if (option as! WrittingOptions).value is JSONSerialization.WritingOptions {
                    return JSONSerialization.WritingOptions.prettyPrinted
                }

                return (option as! WrittingOptions).value
            }
        }
        return nil
    }
    // swiftlint:enable for_where

}
