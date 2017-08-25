//
//  NSLocale+HTTPHeader.swift
//  TrolleyCore
//
//  Created by Harry Wright on 25.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import Foundation

public extension NSLocale {
    @objc public static var acceptLanguage: String {
        return NSLocale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")
    }
}
