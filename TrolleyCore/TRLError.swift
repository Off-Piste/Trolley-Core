//
//  TRLError.swift
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import Foundation

@objc public final class TRLError: NSObject {

    @objc public static func invalidURL(_ url: String) -> Error {
        let msg = "The url entered: \(url) is invalid"
        return NSError(domain: "io.trolley", code: -200, userInfo: [NSLocalizedDescriptionKey:msg])
    }

    @objc public static var urlIsNil: Error {
        let msg = "The operation cannot be processed due to a nil url"
        return NSError(domain: "io.trolley", code: -200, userInfo: [NSLocalizedDescriptionKey:msg])
    }

    @objc public static func parameterEncodingFailed(reason: String) -> Error {
        let msg = "The operation cannot be processed due to a missing parameter: \(reason)"
        return NSError(domain: "io.trolley", code: -200, userInfo: [NSLocalizedDescriptionKey:msg])
    }

}
