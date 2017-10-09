/////////////////////////////////////////////////////////////////////////////////
//
//  Error.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 07.09.17.
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

extension Trolley {

    public struct Error {

        /// :nodoc:
        public typealias Code = TRLError.Code

        /// Error thrown by the TRLNetworkTools when dealing with an invalid URL
        public static let invalidURL: Code = .invalidURL

        /// Error thrown by TRLJSON when the object entered is invalid
        public static let jsonUnsupportedType: Code = .jsonUnsupportedType

        /// Error inisde TRLJSON when the JSON is invalid
        public static let jsonInvalidJSON: Code = .jsonInvalidJSON

        /// Error thrown by TRLJSON when the object entered is invalid
        public static let jsonWrongType: Code = .jsonWrongType

        /// Error thrown by TRLJSON when an subscript is out of bounds
        public static let jsonIndexOutOfBounds: Code = .jsonIndexOutOfBounds

        /// Error thrown by TRLJSON when an subscript cannot find the JSON
        public static let jsonErrorNotExist: Code = .jsonErrorNotExist

        /// Error thrown by `TRLUserDefaults` when UserDefaults returns nil
        public static let defaultsManagerNilReturnValue: Code = .defaultsManagerNilReturnValue

        /// Error thrown by `TRLUserDefaults` when NSKeyedUnarchiver returns nil
        public static let defaultsManagerCouldNotUnarchive: Code = .defaultsManagerCouldNotUnarchive

        /// Error thrown by `TRLUserDefaults` when the value is not a `Class` or `Struct`
        public static let defaultsManagerInvalidValueType: Code = .defaultsManagerInvalidValueType

        /// Error thrown by `TRLUserDefaults` when the value does not conform to `_trl_encodable`
        public static let defaultsManagerInvalidStruct: Code = .defaultsManagerInvalidStruct

        /// Error thrown by TRLOptions when the config file cannot be found
        public static let couldNotFindFile : Code = .optionsCouldNotFindFile

        /// Error thrown by TRLOptions when the DefaultCurrency cannot be found
        public static let invalidDefaultCurrency: Code = .optionsInvalidDefaultCurrency

        /// Error thrown by TRLOptions when the ShopID cannot be found
        public static let missingShopID: Code = .optionsMissingShopID

        /// Error thrown by TRLOptions when the ShopID is invalid
        public static let invalidShopID: Code = .optionsInvalidShopID

        public static let mirrorCouldNotFindDisplayStyle: Code = .mirrorCouldNotFindDisplayStyle

        /// :nodoc:
        public var code: Code {
            return (_nsError as! TRLError).code
        }

        /// :nodoc:
        public var _nsError: NSError

        /// :nodoc:
        public init(_nsError error: NSError) {
            _nsError = error
        }

    }

}

internal func TRLMakeError(_ code: Trolley.Error.Code, _ msg: String? = nil) -> Error {
    var userInfo: [String : Any] = ["Error Code": code.rawValue]
    if let msg = msg {
        userInfo[NSLocalizedDescriptionKey] = msg
    }
    return NSError(domain: Trolley.Error._nsErrorDomain, code: code.rawValue, userInfo: userInfo)
}

extension Trolley.Error : _BridgedStoredNSError {

    /// :nodoc:
    public static var _nsErrorDomain = TRLErrorDomain
}

// MARK: Equatable

extension Trolley.Error: Equatable {}

/// Returns a Boolean indicating whether the errors are identical.
public func == (lhs: Error, rhs: Error) -> Bool {
    return lhs._code == rhs._code
        && lhs._domain == rhs._domain
}

// MARK: Pattern Matching

/**
 Pattern matching matching for `Trolley.Error`, so that the instances can be used with Swift's
 `do { ... } catch { ... }` syntax.
 */
public func ~= (lhs: Trolley.Error, rhs: Error) -> Bool {
    return lhs == rhs
}
