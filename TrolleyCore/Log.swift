/////////////////////////////////////////////////////////////////////////////////
//
//  Log.swift
//  Test
//
//  Created by Harry Wright on 20.09.17.
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
import os

extension OSLog {
    static func applicationLogWithService(_ service: __LoggerService) -> OSLog {
        return OSLog(
            subsystem: Bundle.main.bundleIdentifier ?? "Unknown",
            category: service.rawValue
        )
    }
}

// MARK: - LoggerService

/**
 The Service that the logger is situated in, please extend via swift
 or create a global var in Objc with the current Trolley service you are in.
 Please make sure the rawValue is set to "Trolley/sub_spec_name".

 - warning: Internal Methods
 :nodoc:
 */
@objc(TRLLoggerService)
public final class __LoggerService: NSObject, RawRepresentable {

    public typealias RawValue = String

    @objc public var rawValue: String

    private override init() {
        fatalError()
    }

    @objc public init(rawValue: String) {
        var newValue = rawValue
        if !newValue.contains("Trolley/") {
            newValue = "Trolley/" + newValue
        }

        self.rawValue = newValue
    }

    /// The Core Service, set to Trolley/Core so will show up
    /// like:
    ///
    /// "date time BundleName[PID] [Trolley/Core] msg"
    @objc public static var core: __LoggerService {
        return __LoggerService(rawValue: "Trolley/Core")
    }

}

internal typealias LoggerService = __LoggerService

internal var isLogging: Bool = false

// MARK: - Logger
@objc(TRLLogger)
public final class __Logger: NSObject {

    /// The service for the Logger
    private var service: __LoggerService

    @available(*, unavailable, renamed: "init(withService:)")
    private override init() {
        fatalError()
    }

    /// Initaliser to create a logger class
    /// the service parameter is used to create a new
    /// OSLog with the category as the service
    public init(withService service: __LoggerService) {
        self.service = service
    }

    /// The OSLog for the Logger to use
    private var log: OSLog {
        return OSLog.applicationLogWithService(service)
    }
    
    /// Method used to log the message, due to os_log using StaticString
    /// the logger has to be used more like an Obj-C logger than a swift
    /// print maybe at a later date, will add a few custom methods to allow
    /// the code to play and feel like `Swift.print(_:)`
    ///
    /// - Parameters:
    ///   - msg:    The message or message format.
    ///   - level:  The LoggerLevel, these corrospond with the correct
    ///             OS_LOG_TYPE level
    ///   - args:   The args for the format, can be empty
    public func log(_ msg: StaticString, level: LoggerLevel, args: CVarArg...) {
        self.__log(msg: msg, args: args, level: level)
    }

    private func __log(msg: StaticString, args: [CVarArg], level: LoggerLevel) {
        if !isLogging && level.rawValue == LoggerLevel.debug.rawValue {
            return
        }

        os_log(msg, log: log, type: OSLogType(rawValue: level.rawValue), args)
    }
}

// MARK: - Objective-C Helper Methods
extension __Logger {

    @available(swift, introduced: 1.0, obsoleted: 1.0, renamed: "log(_:level:args:)")
    @objc(log:level:)
    public func __objc_log(_ msg: NSString, level: LoggerLevel) {
        self.log("%@", level: level, args: msg)
    }

    @available(swift, introduced: 1.0, obsoleted: 1.0, renamed: "init(withService:)")
    @objc(loggerForService:)
    public static func loggerForService(_ service: __LoggerService) -> __Logger {
        return __Logger(withService: service)
    }

}

// MARK: - Log Functions

/// The Default Logger, will send a log of .default
///
/// - Parameters:
///   - service: The Current LoggerService you are in.
///   - msg: The log message or log format
///   - args: The objects to be used by the format, can be empty
func TRLLogger(for service: LoggerService, _ msg: StaticString, _ args: CVarArg...) {
    __Logger(withService: service).log(msg, level: .default, args: args)
}

/// The Info Logger, will send a log of .info
///
/// - Parameters:
///   - service:    The Current LoggerService you are in.
///   - msg:        The log message or log format
///   - args:       The objects to be used by the format, can be empty
func TRLInfoLogger(for service: LoggerService, _ msg: StaticString, _ args: CVarArg...) {
    __Logger(withService: service).log(msg, level: .info, args: args)
}

/// The Debug Logger, will send a log of .debug
///
/// - Parameters:
///   - service:    The Current LoggerService you are in.
///   - msg:        The log message or log format
///   - args:       The objects to be used by the format, can be empty
func TRLDebugLogger(for service: LoggerService, _ msg: StaticString, _ args: CVarArg...) {
    __Logger(withService: service).log(msg, level: .debug, args: args)
}

/// The Error Logger, will send a log of .error
///
/// - Parameters:
///   - service:    The Current LoggerService you are in.
///   - msg:        The log message or log format
///   - args:       The objects to be used by the format, can be empty
func TRLErrorLogger(for service: LoggerService, _ msg: StaticString, _ args: CVarArg...) {
    __Logger(withService: service).log(msg, level: .error, args: args)
}

/// The Fault Logger, will send a log of .fault
///
/// - Parameters:
///   - service:    The Current LoggerService you are in.
///   - msg:        The log message or log format
///   - args:       The objects to be used by the format, can be empty
func TRLFaultLogger(for service: LoggerService, _ msg: StaticString, _ args: CVarArg...) {
    __Logger(withService: service).log(msg, level: .fault, args: args)
}
