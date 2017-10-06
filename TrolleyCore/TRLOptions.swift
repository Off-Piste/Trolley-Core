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

/// <#Description#>
@objcMembers public final class TRLOptions: NSObject {

    /// The default `TRLOptions`.
    ///
    /// - Note: Passes the plistName of `TrolleyConfigFile` so if you have changed
    ///         the config files name, please use `init(plistName:)` or
    ///         `[TRLOptions optionsForPlist:]`
    @objc(defaultOptions) public static var `default`: TRLOptions = TRLOptions()

    var xml: XML

    /// Store any errors here so rather than returning nil we can validate
    /// and crash when appropirate and we also can know the correct error.
    var error: Error?

    /// The default `TRLOptions`.
    ///
    /// - Note: Passes the plistName of `TrolleyConfigFile` so if you have changed
    ///         the config files name, please use `init(plistName:)` or
    ///         `[TRLOptions optionsForPlist:]`
    public convenience override init() {
        self.init(plistName: "TrolleyConfigFile")
    }

    /// Initializes a customized instance of TRLOptions from the
    /// file at the given plist file path in the main Bundle
    @nonobjc public convenience init(plistName: String) {
        self.init(bundle: .main, plistname: plistName)
    }

    /// Initializes a customized instance of TRLOptions from the file at
    /// the given plist file path inside a Bundle of your choice
    ///
    /// - Parameters:
    ///   - bundle:     The bundle your file is in.
    ///   - plistname:  The .plist name, defaulted to "TrolleyConfigFile".
    public init(bundle: Bundle, plistname: String = "TrolleyConfigFile") {
        do {
            self.xml = try XMLDecoder(withBundle: bundle, forObject: plistname).xml
        } catch {
            self.xml = .null
            self.error = error
        }
    }

    /// Initializes a customized instance of TRLOptions with keys.
    ///
    /// - Warning: Please note that this may have more items added.
    ///
    /// - Parameters:
    ///   - shopURL:            The shops database URL.
    ///   - shopID:             The shops UUID.
    ///   - defaultCurrency:    The shops default currency, set to GBP if none is added.
    @nonobjc public init(shopURL: String, shopID: String, defaultCurrency: String = "GBP") {
        self.xml = [
            kXMLShopIDKey : shopID,
            kXMLShopURLKey:shopURL,
            kXMLShopDefaultCurrencyKey:defaultCurrency
        ]
    }

    /// Initializes a customized instance of TRLOptions from the
    /// file at the given plist file path in the main Bundle
    @available(swift, introduced: 1.0, obsoleted: 1.2)
    @objc(optionsForPlist:)
    public static func optionsForPlist(_ plist: String) -> TRLOptions {
        return TRLOptions(plistName: plist)
    }

    /// Initializes a customized instance of TRLOptions with keys.
    ///
    /// - Warning: Please note that this may have more items added.
    ///
    /// - Parameters:
    ///   - id:                 The shops UUID.
    ///   - url:                The shops database URL.
    ///   - defaultCurrency:    The shops default currency, if set to nil, GBP is passed.
    /// - Returns:              A customized instance of TRLOptions.
    @available(swift, introduced: 1.0, obsoleted: 1.2)
    @objc(optionsForID:URL:DefaultCurrency:)
    public static func optionsForID(
        _ id: String,
        url: String,
        defaultCurrency: String?
        ) -> TRLOptions
    {
        return TRLOptions(shopURL: url, shopID: id, defaultCurrency: defaultCurrency ?? "GBP")
    }

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

            if self.shopID.first! != "2" {
                let msg = "This API key is not valid for our APIv2, " +
                "please download a new APIKey from http://console.trolleyio.co.uk"
                throw TRLMakeError(Trolley.Error.invalidShopID, msg)
            }
        }

    }

}

extension TRLOptions {

    /// The shop UUID.
    ///
    /// - Note: This contains the shop name, API key and validation elements.
    public var shopID: String {
        return self.xml[kXMLShopIDKey]._bridgeToObjectiveC().stringValue
    }

    /// The URL for the database
    public var shopURL: String {
        return self.xml[kXMLShopURLKey]._bridgeToObjectiveC().stringValue
    }

    /// The name of the Trolley shop.
    public var shopName: String {
        var comp = self.xml[kXMLShopIDKey]._bridgeToObjectiveC().stringValue.components(separatedBy: ":")

        return comp[3]
    }

    /// The shops default currency, this is used by the Trolley/Database to get the correct
    /// currency conversions for the user.
    public var defaultCurrency: String {
        return self.xml[kXMLShopDefaultCurrencyKey]._bridgeToObjectiveC().stringValue
    }

    /// A textual representation of this instance.
    ///
    /// Instead of accessing this property directly, convert an instance of any
    /// type to a string by using the `String(describing:)` initializer. For
    /// example:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public override var description: String {
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
