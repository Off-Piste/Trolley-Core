//
//  Logger.swift
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import Foundation
import TrolleyCore.Private

typealias TRLSwiftService = String

internal func Logger(
    service: TRLSwiftService = kTRLLoggerCore,
    level: LoggerLevel = .notice,
    items: Any...,
    file: String = #file,
    function: String = #function,
    line: UInt = #line,
    seperator: String = " "
    )
{
    TRLLogger.default.printItems(
        items,
        service: service,
        level: level,
        file: file,
        function: function,
        line: line,
        seperator: seperator
    )
}
