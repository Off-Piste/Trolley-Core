/////////////////////////////////////////////////////////////////////////////////
//
//  JSON.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 06.09.17.
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
import TrolleyCore.Dynamic

/// :nodoc:
extension TRLJSON {

    var toCore: JSONCore {
        return JSONCore(self)
    }

}

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }

    func mapPairs<OutKey: Hashable, OutValue>(_ transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }

    func filterPairs(_ includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }
}

/// <#Description#>
public struct JSON {

    internal var _core: JSONCore

    /// <#Description#>
    public var object: Any {
        get {
            return _core.base.object
        }
        set {
            _core.base.object = newValue
        }
    }

    internal init(_core core: JSONCore) {
        self._core = core
    }

    /// <#Description#>
    ///
    /// - Parameter object: <#object description#>
    public init(_ object: Any) {
        self.init(_core: TRLMutableJSON(object).toCore)
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - options: <#options description#>
    /// - Throws: <#throws value description#>
    public init(data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        self._core = TRLJSON(object).toCore
    }

}

public extension JSON {

    /// <#Description#>
    ///
    /// - Parameter key: <#key description#>
    public subscript(key: String) -> JSON {
        get {
            return JSON(_core: _core[key])
        }
        set {
            _core[key] = newValue._core
        }
    }

    /// <#Description#>
    ///
    /// - Parameter index: <#index description#>
    public subscript(index: Int) -> JSON {
        get {
            return JSON(_core: _core[index])
        }
        set {
            _core[index] = newValue._core
        }
    }

}

extension JSON: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }

}

extension JSON: ExpressibleByNilLiteral {

    /// <#Description#>
    public static var null: JSON {
        return self.init(_core: TRLJSON.null().toCore)
    }

    /// <#Description#>
    ///
    /// - Parameter nilLiteral: <#nilLiteral description#>
    public init(nilLiteral: ()) {
        self = .null
    }

}

extension JSON: ExpressibleByBooleanLiteral {

    public init(booleanLiteral value: Bool) {
        self.init(value)
    }

}

extension JSON: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        self.init(value)
    }

}

extension JSON: ExpressibleByArrayLiteral {

    /// The type of the elements of an array literal.
    public typealias Element = Any

    /// Creates an instance initialized with the given elements.
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    /// <#Description#>
    public var array: [JSON]? {
        if self._core.base.rawType == .array {
            return self._core.base.array.map { $0.map { JSON($0.rawValue) } }
        }

        return nil
    }

    /// <#Description#>
    public var arrayValue: [JSON] {
        return self.array ?? []
    }

    /// <#Description#>
    public var arrayObject: [Any]? {
        get {
            if let arr = TRLJSONBaseRawValueForType(self._core.base, .array) as? TRLMutableArray {
                return arr.array()
            }

            return nil
        }
        set {
            if let array = newValue {
                self.object = array
            } else {
                self.object = NSNull()
            }
        }
    }

}

extension JSON: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Float) {
        self.init(value)
    }

}

extension JSON: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (String, Any)...) {
        self.init(dictionaryLiteral: elements)
    }

    public init(dictionaryLiteral dictionary: [(String, Any)]) {
        let jsonFromDictionaryLiteral: ([String : Any]) -> JSON = { dictionary in
            let initializeElement = Array(dictionary.keys).flatMap { key -> (String, Any)? in
                if let value = dictionary[key] {
                    return (key, value)
                }
                return nil
            }
            return JSON(dictionaryLiteral: initializeElement)
        }

        var dict = [String : Any](minimumCapacity: dictionary.count)

        for element in dictionary {
            let elementToSet: Any
            if let json = element.1 as? JSON {
                elementToSet = json.object
            } else if let jsonArray = element.1 as? [JSON] {
                elementToSet = JSON(jsonArray).object
            } else if let dictionary = element.1 as? [String : Any] {
                elementToSet = jsonFromDictionaryLiteral(dictionary).object
            } else if let dictArray = element.1 as? [[String : Any]] {
                let jsonArray = dictArray.map { jsonFromDictionaryLiteral($0) }
                elementToSet = JSON(jsonArray).object
            } else {
                elementToSet = element.1
            }
            dict[element.0] = elementToSet
        }

        self.init(dict)
    }

    /// <#Description#>
    var dictionary: [String: JSON]? {
        if self._core.base.rawType == .dictionary {
            return self._core.base.dictionary?.mapPairs { ($0, JSON($1.toCore)) }
        }
        return nil
    }

    /// <#Description#>
    var dictionaryValue: [String: JSON] {
        return self.dictionary ?? [:]
    }

    /// <#Description#>
    var dictionaryObject: [String: Any]? {
        get {
            if let dict = TRLJSONBaseRawValueForType(self._core.base, .dictionary) as? TRLMutableDictionary, let dictionary = dict.dictionary() as? [String: Any]  {
                return dictionary
            }
            return nil
        }
        set {
            if let dict = newValue {
                self.object = dict
            } else {
                self.object = NSNull()
            }
        }
    }
}

extension JSON: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return _core.base.description
    }

    public var debugDescription: String {
        return _core.base.debugDescription
    }

}

extension JSON: Hashable {

    public var hashValue: Int {
        return _core.hashValue
    }

}

/// <#Description#>
///
/// - Parameters:
///   - lhs: <#lhs description#>
///   - rhs: <#rhs description#>
/// - Returns: <#return value description#>
public func == (lhs: JSON, rhs: JSON) -> Bool {
    return lhs._core == rhs._core
}

/// <#Description#>
///
/// - Parameters:
///   - lhs: <#lhs description#>
///   - rhs: <#rhs description#>
/// - Returns: <#return value description#>
public func == (lhs: JSON, rhs: TRLJSON) -> Bool {
    return lhs._core.base.isEqual(rhs)
}

/// <#Description#>
///
/// - Parameters:
///   - lhs: <#lhs description#>
///   - rhs: <#rhs description#>
/// - Returns: <#return value description#>
public func == (lhs: TRLJSON, rhs: JSON) -> Bool {
    return lhs.isEqual(rhs._core.base)
}
