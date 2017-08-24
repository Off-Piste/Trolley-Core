//
//  TRLMutableJSON.swift
//  TrolleyCore
//
//  Created by Harry Wright on 24.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import Foundation

public class TRLMutableJSON: TRLJSON {

    public var dictionaryObject: [String : Any] {
        get { return self.dictionary }
        set { json.dictionaryObject = newValue }
    }

    public var arrayObject: [Any] {
        get { return self.array }
        set { json.arrayObject = newValue }
    }

    public var boolValue: Bool {
        get { return self.bool }
        set { self.json.bool = newValue }
    }

    public var numberValue: NSNumber {
        get { return self.number }
        set { self.json.number = newValue }
    }

    public var stringValue: String {
        get { return self.string }
        set { self.json.string = newValue }
    }

    public func setValue(_ value: Any?, withKey key: String) {
        switch value {
        case .none: self.json[key].object = NSNull()
        case .some(let W): self.json[key].object = W
        }
    }

    public func setNilForValueWithKey(_ key: String) {
        self.json[key].object = NSNull()
    }

    public func setValue(_ value: Any?) {
        switch value {
        case .none: self.json.object = NSNull()
        case .some(let W): self.json.object = W
        }
    }

}
