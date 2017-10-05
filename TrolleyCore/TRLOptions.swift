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

internal var kXMLShopIDKey: String = "API_KEY"
internal var kXMLShopURLKey: String = "DATABASE_URL"
internal var kXMLShopDefaultCurrencyKey: String = "SHOP_CURRENCY"

@objc public final class TRLOptions: NSObject {

    public static var `default`: TRLOptions = TRLOptions()

    var xml: XML

    var error: Error?

    public convenience override init() {
        self.init(plistName: "TrolleyConfigFile")
    }

    @nonobjc public init(plistName: String) {
        do {
            self.xml = try XMLDecoder(for: plistName).xml
        } catch {
            self.xml = .null
            self.error = error
        }
    }

    public init(bundle: Bundle) {
        do {
            self.xml = try XMLDecoder(withBundle: bundle, forObject: "TrolleyConfigFile").xml
        } catch {
            self.xml = .null
            self.error = error
        }
    }

    public init(shopURL: String, shopID: String, defaultCurrency: String = "GBP") {
        self.xml = [
            kXMLShopIDKey : shopID,
            kXMLShopURLKey:shopURL,
            kXMLShopDefaultCurrencyKey:defaultCurrency
        ]
    }

    @available(swift, introduced: 1.0, obsoleted: 1.2)
    @objc(optionsForPlist:)
    public static func optionsForPlist(_ plist: String) -> TRLOptions {
        return TRLOptions(plistName: plist)
    }

    @available(swift, introduced: 1.0, obsoleted: 1.2)
    @objc(optionsForID:URL:DefaultCurrency:)
    public static func optionsForID(
        _ id: String,
        url: String,
        defaultCurrency: String
        ) -> TRLOptions
    {
        return TRLOptions(shopURL: url, shopID: id, defaultCurrency: defaultCurrency)
    }

    /// - warning: Testing Only
    ///
    /// :nodoc:
    public func validateOrThrow() throws {
        if let error = self.error {
            throw error
        }

        let fmtDefaultMsg: NSString = "The plist is missing %@ please " +
                                      "make sure this is set in your console " +
                                      "at http://console.trolleyio.co.uk " +
                                      "and download a new .plist file" as NSString

        if self.defaultCurrency.isEmpty {
            let msg = NSString(format: fmtDefaultMsg, "the default currency")
            throw TRLMakeError(Trolley.Error.invalidDefaultCurrency, msg as String)
        }

        if self.shopURL.isEmpty {
            let msg = NSString(format: fmtDefaultMsg, "the shop's database URL")
            throw TRLMakeError(Trolley.Error.invalidURL, msg as String)
        }

        if self.shopID.isEmpty {
            let msg = NSString(format: fmtDefaultMsg, "the shop's API key")
            throw TRLMakeError(Trolley.Error.missingShopID, msg as String)
        } else {
            if !self.shopID.contains("ios") {
                let msg = "The API key is invalid, please make sure you are using the iOS key"
                throw TRLMakeError(Trolley.Error.invalidShopID, msg)
            }
            // TODO: Remove this when added to swift 3.2 branch
#if swift(>=4.0)
            if self.shopID.first! != "2" {
                let msg = "This API key is not valid for our APIv2, " +
                "please download a new APIKey from http://console.trolleyio.co.uk"
                throw TRLMakeError(Trolley.Error.invalidShopID, msg)
            }
#else
            if self.shopID.characters.first! != "2" {
                let msg = "This API key is not valid for our APIv2, " +
                "please download a new APIKey from http://console.trolleyio.co.uk"
                throw TRLMakeError(Trolley.Error.invalidShopID, msg)
            }
#endif

        }

    }

}

extension TRLOptions {

    @objc public var shopID: String {
        return self.xml[kXMLShopIDKey]._bridgeToObjectiveC().stringValue
    }

    @objc public var shopURL: String {
        return self.xml[kXMLShopURLKey]._bridgeToObjectiveC().stringValue
    }

    @objc public var shopName: String {
        var comp = self.xml[kXMLShopIDKey]._bridgeToObjectiveC().stringValue.components(separatedBy: ":")

        return comp[3]
    }

    @objc public var defaultCurrency: String {
        return self.xml[kXMLShopDefaultCurrencyKey]._bridgeToObjectiveC().stringValue
    }

    @objc public override var description: String {
        return "\(super.description){id:\(self.shopID) url:\(self.shopURL) currency:\(self.defaultCurrency)}"
    }
}

private class XMLDecoder {

    var xml: XML

    convenience init(for obj: String) throws {
        try self.init(withBundle: .main, forObject: obj)
    }

    init(withBundle bundle: Bundle, forObject object: String) throws {
        guard let path = bundle.path(forResource: object, ofType: ".plist") else {
            throw TRLMakeError(Trolley.Error.couldNotFindFile, "Could not find a valid plist")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let propertyList = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)

        self.xml = XML(propertyList)
    }
}
