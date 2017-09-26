//
//  TRLOptions.swift
//  TRLNetwork
//
//  Created by Harry Wright on 14.09.17.
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

typealias XML = JSON

internal var kXMLShopIDKey: String = ""
internal var kXMLShopURLKey: String = ""
internal var kXMLShopDefaultCurrencyKey: String = ""

@objcMembers
public final class TRLOptions: NSObject {

    public static var `default`: TRLOptions = TRLOptions()

    var xml: XML

    var error: Error?

    public convenience override init() {
        self.init(plistName: "trolley_config")
    }

    @nonobjc public init(plistName: String) {
        do {
            self.xml = try XMLDecoder(for: plistName).xml
        } catch {
            self.xml = .null
            self.error = error
        }
    }

    @available(swift, introduced: 1.0, obsoleted: 1.2)
    @objc(optionsForPlist:)
    public static func optionsForPlist(_ plist: String) -> TRLOptions {
        return TRLOptions(plistName: plist)
    }

    func validateOrRaiseExcpetion() {
        guard let error = self.error else {
            return
        }

        if Trolley.Error.couldNotFindFile ~= error {
            fatalError(error.localizedDescription)
        }
    }

}

extension TRLOptions {

    public var shopID: String {
        return self.xml[kXMLShopIDKey]._bridgeToObjectiveC().stringValue
    }

    public var shopURL: String {
        return self.xml[kXMLShopURLKey]._bridgeToObjectiveC().stringValue
    }

}

private class XMLDecoder {

    var xml: XML

    init(for obj: String) throws {
        guard let path = Bundle.main.path(forResource: obj, ofType: ".plist") else {
            throw TRLMakeError(Trolley.Error.couldNotFindFile, "Could not find a valid plist")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let propertyList = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)

        xml = XML(propertyList)
    }
}
