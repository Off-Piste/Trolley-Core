//
//  Trolley.swift
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import Foundation
import TrolleyCore.Private

@objc public final class Trolley: NSObject {

    @objc public var isLogging: Bool = true

    @objc public static var shared: Trolley {
        return Trolley()
    }

    /// - warning: This must be called before calling
    ///            `.configure()` if you wish to recive
    ///            all Logs to your console
    ///
    /// - Parameter bool: Bool value for if you want logging 
    ///                   or not, defaults at false
    @objc public func setLogging(_ bool: Bool) {
        self.isLogging = bool
        Logger(service: kTRLLoggerCore, level: .info, items: "Logging is set to \(bool)")
    }

}

public extension Trolley {

    public typealias Error = TRLError

}
