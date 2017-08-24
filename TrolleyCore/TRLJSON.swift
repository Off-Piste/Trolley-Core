//
//  TRLJSON.swift
//  TrolleyCore
//
//  Created by Harry Wright on 24.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import Foundation

/// TRLJSON is a SwiftyJSON/Objc port
/// everything runs though SwiftJSON
/// but is designed to be an interface
/// for my Objc Tools
public class TRLJSON: NSObject {

    public internal(set) var json: JSON

    public override init() {
        self.json = JSON.null
    }

    public init(data: Data) {
        self.json = JSON(data: data)
    }

    public init(nullable_data: Data?) {
        if let data = nullable_data {
            self.json = JSON(data: data)
        } else {
            self.json = JSON.null
        }
    }

    public init(_ objects: Any) {
        self.json = JSON(objects)
    }

    internal init(json: JSON) {
        self.json = json
    }

    public override var description: String {
        return json.description
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let json = object as? JSON {
            return json == self.json
        } else if let json = object as? TRLJSON {
            return json.json == self.json
        }

        return super.isEqual(object)
    }
}

extension TRLJSON {

    public subscript(key: String) -> TRLJSON {
        return TRLJSON(json: self.json[key])
    }

    public var error: Error? {
        return self.json.error
    }

    public var dictionary: [String: Any] {
        return self.json.dictionaryObject ?? [:]
    }

    public var string: String {
        return self.json.stringValue
    }

    public var bool: Bool {
        return self.json.boolValue
    }

    public var number: NSNumber {
        return self.json.numberValue
    }

    public var array: [Any] {
        return self.json.arrayObject ?? []
    }

    public var rawString: String {
        return self.json.rawString() ?? ""
    }

    public var rawData: Data? {
        return try? self.json.rawData()
    }

}

// MARK: - NSObject Overrides
extension TRLJSON {

    public override func value(forKey key: String) -> Any? { return self.json[key].object }

    public override func mutableCopy() -> Any { return TRLMutableJSON(json: self.json) }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValue(_ value: Any?, forKey key: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValue(_ value: Any?, forKeyPath keyPath: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValue(_ value: Any?, forUndefinedKey key: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setNilValueForKey(_ key: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValuesForKeys(_ keyedValues: [String : Any]) { }
    
}

extension ObjectiveCSupport {

    public static func convert(object: TRLJSON) -> JSON {
        return object.json
    }

    public static func convert(object: JSON) -> TRLJSON {
        return TRLJSON(json: object)
    }

}

extension Request {

    public func responseJSON(callback: @escaping (JSON?, Error?) -> Void) {
        self.__responseTRLJSON { (json, error) in
            if let error = error {
                callback(nil, error)
            } else {
                callback(ObjectiveCSupport.convert(object: json!), nil)
            }
        }
    }

}
